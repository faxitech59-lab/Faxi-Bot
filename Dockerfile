#=============================================#
#                 v.1.3.7                     #
# █▀▀▀█ █  █ █  █ ▄▀▀▄ ▀█▀ █     █▀▄▀█ █▀▀▄   #
# ▀▀▀▄▄ █  █ █▀▀█ █▄▄█  █  █     █ █ █ █  █   #
# █▄▄▄█ ▀▄▄▀ █  █ █  █ ▄█▄ █▄▄█  █   █ █▄▄▀   #
#     𝗠𝗨𝗟𝗧𝗜𝗗𝗘𝗩𝗜𝗖𝗘 𝗪𝗛𝗔𝗧𝗦𝗔𝗣𝗣 𝗨𝗦𝗘𝗥 𝗕𝗢𝗧        #
#=============================================#
#
#    * @project_name : Suhail-Md
#    * @author : @SuhailTechInfo
#    * @youtube : https://www.youtube.com/SuhailTechInfo
#    * @description : Suhail-Md ,A Multi-functional whatsapp bot md.
#    * @version 1.3.7
# github.com/SuhailTechInfo/Suhail-Md

FROM node:22-bookworm-slim AS node22
FROM quay.io/suhailtechinfo/suhail-v2

# --- Railway fix (2026-10-20) ------------------------------------------------
# The suhail-v2 base image ships Node.js 18.17.1 (Sep 2023). Current
# dependencies (e.g. undici 7, pulled in by cheerio) require Node 20+, so the
# bot crashed at startup with "ReferenceError: File is not defined" and PM2
# kept restarting it forever. The lines below overlay the official Node.js 22
# runtime (binary + bundled npm/corepack) so the bot runs on a modern Node,
# while every tool from the Suhail base image (ffmpeg, webp, git, ...) stays
# exactly as it was.
COPY --from=node22 /usr/local/bin/node /usr/local/bin/node
COPY --from=node22 /usr/local/lib/node_modules /usr/local/lib/node_modules
RUN ln -sf ../lib/node_modules/npm/bin/npm-cli.js /usr/local/bin/npm \
 && ln -sf ../lib/node_modules/npm/bin/npx-cli.js /usr/local/bin/npx \
 && ln -sf ../lib/node_modules/corepack/dist/corepack.js /usr/local/bin/corepack \
 && node -v && npm -v
# -----------------------------------------------------------------------------

# Copy the repository contents into the image (instead of cloning from GitHub)
# so Railway always builds the exact code that was pushed.
WORKDIR /root/smdd
COPY . /root/smdd
RUN rm -rf /root/smdd/.git
RUN npm install || yarn install
EXPOSE 8000
CMD ["npm","start" ]
