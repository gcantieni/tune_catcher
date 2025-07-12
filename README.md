
# Tune Catcher
> record, learn, and master traditional folk tunes

## Goals
- [ ] Recorder
  - [ ] record audio
  - [ ] (stretch goal) identify tunes
- [ ] Tune List
  - [ ] store tunes
  - [ ] fetch data about tunes from tune repositories (names, ABC of different versions, key, type, etc.)
  - [ ] associate the tune entries with sections of recordings
- [ ] Recording list
  - [ ] track personal recordings
  - [ ] track recordings from remote sources like Spotify and YouTube
  - [ ] associate those recordings with tunes from tune list

## Conceptual layout
```text
Presentation layer    
┌─────────────────────┐
│                     │
│   Widgets           │
│                     │
│   States            │
│                     │
│   Controllers       │
│                     │
└─────────┬───────────┘
          │            
          │            
          ▼            
 Application Layer     
┌─────────────────────┐
│                     │
│ Services            │
│                     │
└─────────────────────┘
          ▲            
          │            
          │            
  Data layer           
┌─────────────────────┐
│                     │
│  Model              │
│                     │
│  Database           │
│                     │
└─────────────────────┘
```
