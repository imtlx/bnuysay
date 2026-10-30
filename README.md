# bnuysay

A tiny cowsay-like program written in x86-64 assembly using FASM

## Build

```bash
make
```

## Usage

```bash
bnuysay "silly bnuy"
```

You can also pipe text through stdin:

```bash
echo "oh im so hungry" | bnuysay
```

Or use a file:

```bash
bnuysay < msg.txt
```

## Requirements

- Linux x86-64
- FASM
- Make

---

```
/----------\
| thats it |
\----------/
    \
     \
       (\(\
       ( o.o)
       o_(")(")
```

