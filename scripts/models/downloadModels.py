import asyncio
import aiohttp
from tqdm import tqdm


async def _download(session, url):
    filename = url.split("/")[-1]
    async with session.get(url) as response:
        total = int(response.headers.get("content-length", 0))
        with open(filename, "wb") as f, tqdm(
            total=total, unit="B", unit_scale=True, desc=filename
        ) as bar:
            async for chunk in response.content.iter_chunked(1024):
                f.write(chunk)
                bar.update(len(chunk))

async def download_models(urls):
    async with aiohttp.ClientSession() as session:
        await asyncio.gather(*(_download(session, url) for url in urls))
