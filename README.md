
# Tune Catcher
>
> record, learn, and master traditional folk tunes ❤️ 🪕

## Goals

- [ ] Tune List
  - [ ] store tunes
  - [ ] fetch data about tunes from tune repositories (names, ABC of different versions, key, type, etc.)
  - [ ] provide practicing assistance for committing tunes to memory
  - [ ] associate the tune entries with sections of recordings
- [ ] Set lists
  - [ ] create set lists that reference tunes from tune list
  - [ ] provide practicing assistance for committing sets to memory and practicing transitions
- [ ] Recorder
  - [ ] record audio
  - [ ] (stretch goal) identify tunes
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

## Architectural layout

By separating the business logic from the user interface, we can prevent direct code dependence of business logic on UI elements. The ViewModel presents a programming interface for separaring the data manipulation and modification concerns from UI elements that are rendered, interacted with, and updated.

By separating the business logic from the data contained in the model itself, we simplify the code that represents the data to just CRUD operations on the data we manage.

![Model-View-ViewModel architecture](mvvm.png)

Source: [Code with Andrea](https://codewithandrea.com/articles/comparison-flutter-app-architectures/)

References:

- <https://www.xavor.com/blog/bloc-vs-riverpod/>
- <https://codewithandrea.com/articles/flutter-app-architecture-riverpod-introduction/>
- <https://riverpod.dev/>
- <https://github.com/fluttergems/awesome-open-source-flutter-apps>
