# i2i Systems SQL Case Study 🚀

Bu proje, bir telekomünikasyon veritabanı şeması üzerinde gerçekleştirilen veri analizi ve SQL sorgulama çalışmalarını içermektedir. i2i Systems staj programı kapsamında hazırlanmıştır.

## 🛠 Kullanılan Teknolojiler
* **Database:** Oracle Database Express Edition (Oracle XE)
* **Environment:** Docker
* **Tool:** DBeaver
* **Language:** SQL (PL/SQL)

## 📊 Proje Yapısı
* `setup.sql`: Veritabanı tablolarının (Tariffs, Customers, Monthly_Stats) oluşturulması ve Foreign Key bağlantıları.
* `solutions.sql`: Proje kapsamında istenen 6 ana analiz sorgusu ve açıklamaları.
* `/data`: Analizde kullanılan ham veri setleri (CSV).

## 🧠 Öğrenilen Kazanımlar
* Oracle veritabanı üzerinde karmaşık tablo ilişkileri kurma.
* `JOIN`, `GROUP BY` ve `AVG/COUNT` gibi fonksiyonlarla büyük veri setlerinden anlamlı raporlar çıkarma.
* Docker üzerinde veritabanı yönetimi ve DBeaver ile SQL geliştirme.

---
**Prepared by:** Onur Zorlu - *Final Year Computer Programming Student*








## 🚀 Bonus Task: Docker Compose ile Veritabanı Kurulumu

Bu projede, veritabanı ortamının herkes tarafından kolayca ve aynı standartlarda kurulabilmesi için **Docker Compose** kullanılmıştır. Olası port çakışmalarını önlemek adına dış port `1522` olarak yapılandırılmıştır.

### Adım 1: Veritabanını Başlatma
Proje dizininde komut satırını (CMD/PowerShell veya Bash) açarak aşağıdaki komutu çalıştırın:
```shell
docker-compose up -d
```
<img width="960" height="298" alt="terminal" src="https://github.com/user-attachments/assets/d7173cd6-0eba-490c-9488-4e965caea1a0" />
Veritabanı hazır hale geldikten sonra DBeaver (veya tercih ettiğiniz bir SQL istemcisi) üzerinden aşağıdaki yapılandırma ile bağlantı sağlayabilirsiniz:

Host: localhost

Port: 1522

Database: XE

Username: system

Password: i2iPassword123

Bağlantı testi başarılı olduğunda sistem aşağıdaki gibi yanıt verecektir:
<img width="957" height="1075" alt="ss6" src="https://github.com/user-attachments/assets/459cf847-590d-4bd5-8b30-6bd1be4b3b13" />


