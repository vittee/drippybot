FROM ubuntu:noble

LABEL org.opencontainers.image.source="https://github.com/vittee/drippybot"
LABEL org.opencontainers.image.description="DrippyBot"
LABEL org.opencontainers.image.author="Wittawas Nakkasem <vittee@hotmail.com>"
LABEL org.opencontainers.image.url="https://github.com/vittee/drippybot/blob/main/README.md"
LABEL org.opencontainers.image.licenses=MIT

ENV TZ=UTC

RUN apt update -y

RUN apt install fzf cups printer-driver-escpr -y

COPY entrypoint.sh /
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
