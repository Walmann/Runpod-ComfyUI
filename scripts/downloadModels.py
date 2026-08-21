#!/usr/bin/env python3
import os
import sys
import time
import argparse
from concurrent.futures import ThreadPoolExecutor, as_completed
from urllib.request import urlretrieve
from urllib.error import URLError, HTTPError
from tqdm import tqdm

def download_file(url, dest_path, pbar_lock=None):
    """Last ned en enkelt fil og oppdater den felles fremgangsindikatoren."""
    try:
        # Hent filstørrelse først for å sette riktig total i progressbaren
        try:
            import urllib.request
            req = urllib.request.Request(url, headers={'User-Agent': 'Mozilla/5.0'})
            with urllib.request.urlopen(req, timeout=10) as response:
                total_size = int(response.headers.get('Content-Length', 0))
        except:
            total_size = 0
        
        bytes_downloaded = [0]
        
        # Last ned filen med progress-opptelling
        def hook(count, block_size, total_size_inner):
            if count > 0:
                downloaded = count * block_size
                if pbar_lock:
                    with pbar_lock:
                        # Beregn hva vi har lastet ned denne gangen
                        delta = downloaded - bytes_downloaded[0]
                        bytes_downloaded[0] = downloaded
                        # Oppdater progressbaren med delta (men vi bruker kun fil-forkast her)
        
        # Opprett målmappe hvis den ikke finnes
        dest_dir = os.path.dirname(dest_path)
        if dest_dir:
            os.makedirs(dest_dir, exist_ok=True)
        
        # Last ned filen
        urlretrieve(url, dest_path, reporthook=hook)
        
        return True, None, dest_path
    except Exception as e:
        return False, str(e), None

def parse_config(config_file):
    """Les konfigurasjonsfil med URL og målmappe på hver linje."""
    tasks = []
    with open(config_file, 'r') as f:
        for line_num, line in enumerate(f, 1):
            line = line.strip()
            if not line or line.startswith('#'):
                continue
            
            # Format: URL|MÅLMAPPE eller URL MÅLMAPPE (med tab mellom)
            if '|' in line:
                parts = line.split('|', 1)
            elif '\t' in line:
                parts = line.split('\t', 1)
            else:
                parts = line.split(None, 1)
            
            if len(parts) == 2:
                url, dest_dir = parts
            else:
                print(f"Advarsel Linje {line_num} ignoreres (krav: URL og mappe): {line}", file=sys.stderr)
                continue
            
            tasks.append((url.strip(), dest_dir.strip()))
    
    return tasks

def main():
    parser = argparse.ArgumentParser(description='Last ned mange filer parallelt til forskjellige mapper med visuell fremgang.')
    
    # Alternativ 1: Konfigurasjonsfil
    parser.add_argument('-c', '--config', help='Konfigurasjonsfil med format: URL|MÅLMAPPE (én per linje)')
    
    # Alternativ 2: Direkte URL-liste med optionale mapper
    parser.add_argument('urls_or_maps', nargs='*', help='URL-er og valgfrie målmapper (parvis: URL MAPPE URL MAPPE...)')
    
    # Felles alternativer
    parser.add_argument('-w', '--workers', type=int, default=4, 
                        help='Antall parallelle tråder (standard: 4)')
    parser.add_argument('--default-dir', default='./downloads',
                        help='Standard mappe hvis ingen spesifisert (standard: ./downloads)')
    
    args = parser.parse_args()
    
    tasks = []
    
    # Les fra konfigurasjonsfil hvis oppgitt
    if args.config:
        if not os.path.exists(args.config):
            print(f"Fikk ikke funnet konfigurasjonsfil: {args.config}", file=sys.stderr)
            return 1
        tasks = parse_config(args.config)
    
    # Hvis ingen config-fil, prøv direkte CLI argumenter
    if not tasks and args.urls_or_maps:
        args_list = args.urls_or_maps
        i = 0
        while i < len(args_list):
            url = args_list[i]
            
            # Sjekk om neste argument ser ut som en mappe (ikke en URL)
            next_is_map = False
            if i + 1 < len(args_list):
                next_arg = args_list[i + 1]
                # Hvis neste argument ikke starter med http og inneholder ikke spesialtegn fra URL
                if not (next_arg.startswith('http://') or next_arg.startswith('https://')):
                    next_is_map = True
            
            if next_is_map:
                dest_dir = args_list[i + 1]
                i += 2
            else:
                dest_dir = args.default_dir
                i += 1
            
            # Hent filnavn fra URL
            filename = os.path.basename(url.split('?')[0])
            if not filename:
                filename = f"file_{len(tasks)+1}"
            
            dest_path = os.path.join(dest_dir, filename)
            tasks.append((url, dest_path))
    
    if not tasks:
        print("Ingen nedlastingsoppgaver oppdaget. Bruk enten:")
        print("  1. --config <fil> med format: URL|MÅLMAPPE")
        print("  2. URL MAPPE URL MAPPE ... (parvis)")
        print("\nEksempel: ./batch_downloader.py https://ex.com/a.zip ./folder/a https://ex.com/b.zip ./backup/b")
        return 1
    
    print(f"\n🚀 Starter nedlasting av {len(tasks)} filer til ulike mapper med {args.workers} tråder...\n")
    
    # Start nedlastingene
    start_time = time.time()
    successful = 0
    failed = 0
    failed_tasks = []
    
    # For tråd-sikker oppdatering av progressbar
    from multiprocessing import Lock
    pbar_lock = Lock()
    
    with ThreadPoolExecutor(max_workers=args.workers) as executor:
        future_to_task = {}
        for idx, (url, dest_path) in enumerate(tasks):
            future = executor.submit(download_file, url, dest_path, pbar_lock)
            future_to_task[future] = (idx, url, dest_path)
        
        with tqdm(total=len(tasks), desc="Nedlasting", unit="fil") as pbar:
            for future in as_completed(future_to_task):
                idx, url, dest_path = future_to_task[future]
                
                try:
                    success, error, saved_path = future.result()
                    
                    if success:
                        successful += 1
                        pbar.set_postfix_str(f"Succé: {successful}/{len(tasks)}")
                        print(f"✅ {os.path.basename(saved_path)} → {saved_path}")
                    else:
                        failed += 1
                        pbar.set_postfix_str(f"Feil: {failed}, Succé: {successful}")
                        print(f"❌ Feil ved nedlasting av {url}: {error}", file=sys.stderr)
                        failed_tasks.append((url, error))
                    
                    pbar.update(1)
                except Exception as e:
                    failed += 1
                    print(f"❌ Uventet feil ved {url}: {e}", file=sys.stderr)
                    failed_tasks.append((url, str(e)))
                    pbar.update(1)
    
    end_time = time.time()
    duration = end_time - start_time
    
    # Oppsummering
    print("\n" + "="*60)
    print("📊 NEDLASTINGSRAPPORT")
    print("="*60)
    print(f"✅ Lykkelige nedlastinger: {successful}/{len(tasks)}")
    print(f"❌ Mislykkede nedlastinger: {failed}")
    print(f"⏱️ Total tid: {duration:.2f} sekunder ({duration/60:.1f} min)")
    print("="*60)
    
    if failed_tasks:
        print("\n❌ MISLYKKEDE NEDLASTINGER:")
        print("-"*60)
        for url, error in failed_tasks:
            print(f"   {url}")
            print(f"      Feilmelding: {error}")
        print("-"*60)
    
    if failed == 0:
        print("\n🎉 Alle filer er ferdig lastet ned til sine respektive mapper!")
    else:
        print(f"\n⚠️ {failed} filer feilet. Sjekk detaljer ovenfor.")
    
    return 0 if failed == 0 else 1

if __name__ == "__main__":
    sys.exit(main())