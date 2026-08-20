# Downloader 

Downloader for the hw project

## yt-dlp Options

Full list, split by `progress.*` (from the download progress dict) and `info.*` (any field from the video's info dict,
i.e. same fields as `-o`/`--print`).

**`progress.*` — raw values**

| Field                           | Meaning                                              | 
|---------------------------------|------------------------------------------------------|
| `progress.status`               | `downloading`, `finished`, `error`                   |
| `progress.filename`             | destination filename                                 |
| `progress.tmpfilename`          | temp filename during download                        |
| `progress.downloaded_bytes`     | bytes downloaded so far                              |
| `progress.total_bytes`          | total size (if known)                                |
| `progress.total_bytes_estimate` | estimated total (if size unknown, e.g. live/chunked) |
| `progress.elapsed`              | seconds elapsed                                      |
| `progress.eta`                  | seconds remaining                                    |
| `progress.speed`                | bytes/sec                                            |
| `progress.fragment_index`       | current fragment number (fragmented downloads)       |
| `progress.fragment_count`       | total fragment count                                 |

**`progress.*` — pre-formatted display strings** (human-readable, e.g. `"45.3%"`, `"1.2MiB/s"`, `"N/A"` if unavailable):

| Field                                | Meaning                            |
|--------------------------------------|------------------------------------|
| `progress._percent_str`              | percent complete                   |
| `progress._downloaded_bytes_str`     | downloaded, human size             |
| `progress._total_bytes_str`          | total, human size                  |
| `progress._total_bytes_estimate_str` | estimated total, human size        |
| `progress._elapsed_str`              | elapsed, human time                |
| `progress._eta_str`                  | ETA, human time                    |
| `progress._speed_str`                | speed, human rate                  |
| `progress._default_template`         | yt-dlp's own default progress line |

**`info.*`** — every key from the video's info dict is available, same set as `-o`/`--print` output template fields.
Most common ones:

```
info.id, info.title, info.fulltitle, info.ext, info.filename
info.duration, info.filesize, info.filesize_approx
info.uploader, info.upload_date, info.webpage_url, info.format_id
```

Full list: `yt-dlp -j "URL"` and inspect the JSON keys — that JSON *is* the info dict.

**Postprocess-only extra:** when using `postprocess:` prefix, `progress.postprocessor` gives the current postprocessor
name (e.g. `Merger`, `FFmpegVideoConvertor`).
