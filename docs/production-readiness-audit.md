# Production Readiness Audit

Bu dokuman 2026-03-17 tarihinde mevcut repository durumu incelenerek hazirlandi.
Amac: oyunu "prod ready" hale getirmek icin eksikleri tek yerde toplamak ve sonraki turlarda bu dosya uzerinden ilerlemek.

## Incelenen Alanlar

- `project.godot`
- `docs/`
- `scenes/`
- `scripts/`
- `resources/`
- `assets/`

## Mevcut Durum Ozeti

Oyun temel loop acisindan calisabilir durumda:

- menu -> gameplay -> game over akisi var
- classic ve survival modlari var
- save/load, profile, local scoreboard ve store var
- asker spawn, dusman spawn, combat ve economy akislari mevcut

Ancak production oncesi hala eksik olan ana katmanlar var:

- audio yok
- settings UI yok
- export/release konfigurasyonu yok
- login/cloud/service entegrasyonlari yok
- pause/onboarding/polish katmani eksik
- launch operasyonu icin gerekli dis isi yuksek

## 1. AI'nin Dogrudan Duzeltebilecegi Kisimlar

Bu maddeler repository icinde kod ve scene degisikligiyle guvenli sekilde yapilabilir.

### P0 - Release oncesi tamamlanmali

- [ ] Settings ekrani ve menu erisimi
  Kanit: save tarafinda `settings.sfx_volume` ve `settings.music_volume` var, ama buna bagli UI veya scene yok.
  Referans: `scripts/autoloads/save_manager.gd`, `scenes/main_menu/main_menu.gd`

- [ ] Audio sistemi altyapisi
  Kanit: repo icinde ses dosyasi yok, `AudioStreamPlayer` kullanimi yok, gameplay/menu/game over sahnelerinde audio node'u yok.
  Not: final ses asset'lerini sen saglamalisin; ben sistemi ve baglantilari kurabilirim.

- [ ] Pause menusu
  Kanit: gameplay icinde pause button, overlay, resume/quit akisi yok.
  Referans: `scenes/gameplay/gameplay.tscn`, `scenes/gameplay/gameplay.gd`

- [ ] Ilk acilis / tutorial / onboarding
  Kanit: mevcut akista oyuncuya swipe, hold-to-cycle ve asker ekonomisini anlatan hicbir rehber yok.
  Referans: `scripts/systems/touch_input.gd`, `scenes/main_menu/main_menu.tscn`

- [ ] Runtime settings uygulama katmani
  Kanit: save semasinda volume alanlari var ama oyunda bu degerleri kullanan hicbir kod yok.
  Referans: `scripts/autoloads/save_manager.gd:82`

### P1 - Production kalitesi icin guclu adaylar

- [ ] Basit VFX / hit feedback / death feedback
  Kanit: `GameWorld/Effects` node'u bos ve kullanilmiyor.
  Referans: `scenes/gameplay/gameplay.tscn`

- [ ] UI polish ve feedback mesajlari
  Ornekler:
  - yetersiz coin durumunda toast/uyari
  - premium kilitli unit icin acik mesaj
  - satin alma sonrasi daha net feedback
  Kanit: store ve gameplay akislari sessiz fail ediyor.
  Referans: `scenes/gameplay/gameplay.gd:82`, `scenes/ui/soldier_store.gd:44`, `scenes/ui/soldier_card.gd:49`

- [ ] Profile ekraninda acik save feedback'i
  Kanit: isim sadece `text_changed` ile dirty yapiliyor; kullaniciya kaydedildi feedback'i yok.
  Referans: `scenes/ui/profile.gd:33`, `scripts/autoloads/save_manager.gd:95`

- [ ] Settings, pause ve onboarding icin local persistence
  Kanit: save sistemi hazir, fakat bu ozellikler henuz save ile gercek bag kurmuyor.

- [ ] Basit accessibility / usability iyilestirmeleri
  Ornekler:
  - daha belirgin low-time warning
  - daha okunur HUD spacing
  - buton state mesajlari

### P2 - AI yapabilir ama urun kararina bagli

- [ ] Local achievements / progression polish
- [ ] Daha zengin scoreboard sunumu
- [ ] Basit quality presets veya gameplay options

## 2. Senin Yapman Gereken Kisimlar

Bu maddeler product, content, store, servis veya operasyon karari gerektiriyor. Kod tarafinda yardim edebilirim ama sahiplik sende olmali.

### P0 - Gercek release blocker

- [ ] Final ses efektleri ve muzik asset'leri
  Durum: repository'de `.wav`, `.ogg`, `.mp3` dosyasi yok.
  Ben ne yapabilirim: import, bus yapisi, volume baglama, tetikleme.

- [ ] Export presetleri, bundle/package kimlikleri ve signing
  Durum: repo kokunde `export_presets.cfg` yok.
  Bu olmadan store build zinciri hazir degil.

- [ ] Gercek cihaz testi
  Yapilmasi gerekenler:
  - en az 1 iOS / 1 Android cihazda performans
  - notch / farkli aspect ratio kontrolu
  - touch hissi ve readability kontrolu

- [ ] Store operasyonlari
  Yapilmasi gerekenler:
  - store listing metinleri
  - screenshot/video
  - ikonlar / feature graphic
  - age rating / category secimi
  - privacy policy ve support info

### P1 - Servis ve ticari kararlar

- [ ] Login / account sistemi gerekip gerekmedigine karar
  Mevcut durum: hicbir auth, backend, cloud save veya online profile sistemi yok.
  Not: bu oyun su an local save ile calisiyor; login zorunlu degil.
  Login ancak su ihtiyaclar varsa mantikli:
  - cloud save
  - cihazlar arasi progression
  - online leaderboard
  - sosyal / account-based ekonomi

- [ ] Analytics ve crash reporting saglayicisi secimi
  Ornekler: Firebase Analytics, Crashlytics, Sentry, GameAnalytics.
  Ben secilen servise gore entegrasyonu yapabilirim.

- [ ] Monetization karari
  Kanit: save semasinda `ads_removed` var ve `SoldierData` icinde `is_premium` alani var, fakat implementation yok.
  Referans: `scripts/autoloads/save_manager.gd:73`, `scripts/data/soldier_data.gd:26`

- [ ] Online leaderboard isteyip istemedigine karar
  Mevcut durum: scoreboard sadece local save'dan okunuyor.
  Referans: `scenes/ui/scoreboard.gd`

### P2 - Content ownership

- [ ] Final balancing karari
  Ben veri tarafini duzenleyebilirim ama nihai fun/balance karari oyun sahibi olarak sende olmali.

- [ ] Final art/VFX/SFX kalitesi
  Ben placeholder veya teknik entegrasyon yapabilirim; final production kalite ciktisi genelde insan dokunusu ister.

## 3. Karar Gerektiren Basliklar

Bunlar dogrudan "eksik" ama hepsi zorunlu degil. Once urun hedefini netlestirmek gerekir.

- [ ] Login
  Su an yok. Local single-player oyun icin zorunlu degil.

- [ ] Cloud save
  Su an yok. Login/back-end karariyla birlikte dusunulmeli.

- [ ] Ads / IAP
  Veri modeli buna isaret ediyor ama urun stratejisi belli degil.

- [ ] Online servisler
  Analytics, remote config, push, events, live ops gibi servisler henuz yok.

## 4. Kod ve Repo Temelli Kanitlar

- `project.godot`
  - main scene var, mobile config var, theme var
  - audio bus veya export preset bilgisi repo seviyesinde yok

- `scripts/autoloads/save_manager.gd`
  - `settings.sfx_volume` ve `settings.music_volume` tanimli
  - `ads_removed` alani tanimli
  - save sistemi local JSON bazli

- `scenes/main_menu/main_menu.gd`
  - settings butonu yok
  - sadece classic, survival, scores, profile, store navigasyonu var

- `scenes/gameplay/gameplay.gd`
  - gameplay loop mevcut
  - pause/state overlay yok
  - ses veya feedback hook'lari yok

- `scenes/ui/scoreboard.gd`
  - scoreboard local save datasindan uretiliyor
  - online servis baglantisi yok

- `scripts/data/soldier_data.gd`
  - `is_premium` alani var
  - premium / IAP tarafinda gelecekte kullanilmak uzere hazir ama aktif degil

- `assets/`
  - ses dosyasi bulunmadi

- repo root
  - `export_presets.cfg` bulunmadi

## 5. Onerilen Ilk Sprint

Prod-ready hedefi icin ilk en mantikli sprint su:

1. Settings ekrani + volume persistence + audio bus altyapisi
2. Pause menusu
3. Onboarding / ilk acilis tutorial'i
4. Yetersiz coin / satin alma / state feedback polish'i
5. Export hazirligi icin checklist sabitleme

## 6. Takip Formati

Sonraki turlarda bu dosyada her maddeyi su sekilde guncelleyebiliriz:

- `TODO`
- `IN PROGRESS`
- `DONE`
- `BLOCKED`

## 7. Bu Tura Ait Dogrulama

Yapilan dogrulamalar:

- dosya ve sahne taramasi yapildi
- save/gameplay/menu/store/profile/scoreboard akislari incelendi
- headless Godot acilisi calistirildi: basarili

Yapilmayanlar:

- cihaz uzerinde manuel gameplay QA
- iOS/Android export alma
- store submission dry-run
- ses/video/marketing asset kalite kontrolu
