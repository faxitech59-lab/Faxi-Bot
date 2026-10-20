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

FROM node:20-bookworm-slim AS node20
FROM quay.io/suhailtechinfo/suhail-v2

# --- Railway fix v2 (2026-10-20) ---------------------------------------------
# The suhail-v2 base image ships Node.js 18.17.1 (Sep 2023). Current
# dependencies (e.g. undici 7, pulled in by cheerio) require Node 20+, so the
# bot crashed at startup with "ReferenceError: File is not defined" and PM2
# kept restarting it forever.
# Node 20 (not 22) is used on purpose: canvas@2.11.2 ships prebuilt binaries
# for Node 20, while Node 22 has none and its source compile fails here.
# The old Node 18 npm/corepack files are removed FIRST so stale files cannot
# mix into the new npm tree (that mix broke node-gyp in fix v1). Every tool
# from the Suhail base image (ffmpeg, webp, git, ...) stays untouched.
RUN rm -rf /usr/local/lib/node_modules/npm /usr/local/lib/node_modules/corepack \
           /usr/local/bin/node /usr/local/bin/npm /usr/local/bin/npx /usr/local/bin/corepack
COPY --from=node20 /usr/local/bin/node /usr/local/bin/node
COPY --from=node20 /usr/local/lib/node_modules /usr/local/lib/node_modules
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
