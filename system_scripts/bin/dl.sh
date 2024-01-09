#!/bin/sh 

youtube-dl \
				--batch-file $1 \
				--ignore-errors \
				--no-warnings \
				--sleep-interval 5 \
				--extract-audio \
				--audio-format mp3 \
				--audio-quality 0 \
				--prefer-ffmpeg \
				--continue \
				--yes-playlist \
				--retries 5 \
				--limit-rate 50K
				
# 				--batch-file ./list.txt			
#				--external-downloader [command]
#				--external-downloader-args [args]
#				--age-limit 5
#				--min-views
#				--max-views
			
				