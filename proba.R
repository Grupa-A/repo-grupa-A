title: "Analiza Danych Agencji Nieruchomości"
author: "Kinga Derewecka, Piotr Bochiński"
date: "`r Sys.Date()`"
output: html_document

as.ordered(agencja_nieruchomosci$stories)

#Price: Cena nieruchomości.
#Area: Całkowita powierzchnia domu w stopach kwadratowych.
#Bedrooms: Liczba sypialni w domu.
#Bathrooms: Liczba łazienek w domu.
#Stories: Liczba pięter w domu.
#Mainroad: Czy dom jest połączony z główną drogą (Tak/Nie).
#Guestroom: Czy dom posiada pokój gościnny (Tak/Nie).
#Basement: Czy dom jest podpiwniczony (Tak/Nie).
#Hot water heating: Czy dom posiada system ogrzewania ciepłej wody (Tak/Nie).
#Airconditioning: Czy dom posiada system klimatyzacji (Tak/Nie).
#Parking: Liczba miejsc parkingowych dostępnych w budynku.
#Prefarea: Czy dom znajduje się w preferowanym obszarze (Tak/Nie).
#Furnishing status: Status umeblowania domu (w pełni umeblowany,
#częściowo umeblowany, nieumeblowany).


price <- agencja_nieruchomosci$price

labels(agencja_nieruchomosci)

area <- agencja_nieruchomosci$area

bedrooms <- agencja_nieruchomosci$bedrooms

bathrooms <- agencja_nieruchomosci$bathrooms


stories <- agencja_nieruchomosci$stories

mainroad <- agencja_nieruchomosci$mainroad

guestroom <- agencja_nieruchomosci$guestroom

basement <- agencja_nieruchomosci$basement

hotwater <- agencja_nieruchomosci$hotwaterheating

aircondition <- agencja_nieruchomosci$airconditioning

parking <- agencja_nieruchomosci$parking

prefarea <- agencja_nieruchomosci$prefarea

furnishing <- agencja_nieruchomosci$furnishingstatus


---
  
  ```{r setup, include=FALSE}
install.packages("DMwR2")
install.packages("magrittr")
library(DMwR2)
library(magrittr)
```

## Wprowadzenie

Analiza danych agencji nieruchomości stanowi kluczowe narzędzie w zrozumieniu dynamicznych aspektów rynku nieruchomości. W ramach tego projektu, przeprowadzimy szczegółową analizę zestawu danych, który zawiera informacje na temat 13 zmiennych istotnych dla charakteryzacji nieruchomości. Te dane obejmują aspekty, takie jak cena nieruchomości, liczba sypialni, łazienek, a także różnorodne udogodnienia i cechy domów.

Celem naszej analizy jest zidentyfikowanie istotnych zależności, które mogą mieć wpływ na ceny nieruchomości. Będziemy badać zarówno zmienne ilościowe, jak i jakościowe, aby uzyskać pełniejszy obraz rynku nieruchomości. Analiza ta może dostarczyć istotnych wskazówek dla agencji nieruchomości, inwestorów czy potencjalnych nabywców, pomagając im podejmować bardziej świadome decyzje.

## Czyszczenie danych

W pierwszym etapie naszej analizy skoncentrujemy się na procesie czyszczenia danych, co obejmuje identyfikację, zarządzanie i eliminację potencjalnych nieprawidłowości w danych.

### Brakujące obserwacje

```{r}
```

### Obserwacje odstające

Kolejnym krokiem jest zidentyfikowanie obserwacji odstających, ponieważ mogą one wpływać na wynik analizy i prowadzić do błędnych wniosków.

```{r}
for (col in colnames(agencja)) {
  if (is.numeric(agencja[[col]])) {
    boxplot(agencja[[col]], 
            main = paste("Wykres Ramkowy dla", col), 
            ylab = col,
            col = "skyblue",
            border = "darkblue",
            pch = 19,
            cex = 1.5
    )
  }
}
```

Cena: Kilka nieruchomości ma znacznie wyższą cenę niż pozostałe, co może świadczyć o ich wysokim standardzie, atrakcyjnej lokalizacji lub innych cechach podnoszących wartość. Powierzchnia: Niektóre nieruchomości mają bardzo dużą powierzchnię, co może oznaczać, że są to domy jednorodzinne lub posiadają dużą ilość pięter. Liczba sypialni: Niektóre nieruchomości mają 5 i 6 sypialni, co jest znacznie więcej niż średnia. Może to być związane z dużą powierzchnią lub specyficznym układem pomieszczeń. Liczba łazienek: Jedna nieruchomość ma 4 łazienki. Może to być związane z dużą liczbą sypialni lub wysokim standardem. Liczba pięter: Kilka nieruchomości ma 4 piętra. Może to oznaczać, że są to domy z poddaszem lub piwnicą. Liczba miejsc parkingowych: Niektóre nieurchomości mają 3 miejsca parkingowe.Może to oznaczać, że są to domy z garażem lub podjazdem.

```{r}
for (col1 in colnames(agencja)) {
  for (col2 in colnames(agencja)) {
    if (is.numeric(agencja[[col1]]) && is.numeric(agencja[[col2]]) && col1 != col2) {
      plot(agencja[[col1]], agencja[[col2]], 
           main = paste("Wykres Rozrzutu dla", col1, "i", col2),
           xlab = col1, ylab = col2)
    }
  }
}
```

```{r}
conditions <- data.frame(
  price = abs(scale(agencja$price)) > 3,
  area = abs(scale(agencja$area)) > 3,
  bedrooms = abs(scale(agencja$bedrooms)) > 3,
  bathrooms = abs(scale(agencja$bathrooms)) > 3,
  stories = abs(scale(agencja$stories)) > 3,
  parking = abs(scale(agencja$parking)) > 3
)
summary(conditions)
```

Cena: 6 z 545 nieruchomości ma cenę, która jest odstająca. Powierzchnia: 7 z 545 nieruchomości ma powierzchnię, która jest odstająca. Liczba sypialni: 2 z 545 nieruchomości ma liczbę sypialni, która jest odstająca. Liczba łazienek: 11 z 545 nieruchomości ma liczbę łazienek, która jest odstająca. Liczba pięter: Żadna z 545 nieruchomości nie ma liczby pięter, która jest odstająca. Może to oznaczać, że wszystkie nieruchomości mają podobną liczbę pięter lub że zmienna stories nie ma rozkładu normalnego. Liczba miejsc parkingowych: Żadna z 545 nieruchomości nie ma liczby miejsc parkingowych, która jest odstająca. Może to oznaczać, że wszystkie nieruchomości mają podobną liczbę miejsc parkingowych lub że zmienna parking nie ma rozkładu normalnego.

```{r}
library(outliers)
grubbs.test(agencja$price)
grubbs.test(agencja$area)
grubbs.test(agencja$bedrooms)
grubbs.test(agencja$bathrooms)
grubbs.test(agencja$stories)
grubbs.test(agencja$parking)
```

Cena: Najwyższa wartość ceny, czyli 13300000, jest odstająca. Powierzchnia: Najwyższa wartość powierzchni, czyli 16200, jest odstająca. Liczba sypialni: Najwyższa wartość liczby sypialni, czyli 6, jest odstająca. Liczba łazienek: Najwyższa wartość liczby łazienek, czyli 4, jest odstająca. Liczba pięter: Najwyższa wartość liczby pięter, czyli 4, nie jest odstająca. Liczba miejsc parkingowych: Najwyższa wartość liczby miejsc parkingowych, czyli 3, nie jest odstająca.

### Walidacja danych

```{r}
#sprawdzenie czy dane mają poprawny typ
str(agencja)
summary(agencja)
#sprawdzenie czy dane nie mają duplikatów
anyDuplicated(agencja)
#sprawdzenie czy cena nieruchomości jest przechowywana jako liczba
all(sapply(agencja$price, function(x) is.numeric(x)))
#sprawdzenie czy powierzchnia jest przechowywana jako liczba
all(sapply(agencja$area, function(x) is.numeric(x)))
# sprawdzenie czy liczba sypialni jest liczbą całkowitą i nieujemną
all(agencja$bedrooms %% 1 == 0) && all(agencja$bedrooms >= 0)
#sprawdzenie czy liczba łazienek jest liczbą całkowitą i nieujemną
all(agencja$bathrooms %% 1 == 0) && all(agencja$bathrooms >= 0)
#sprwdzenie czy liczba pięter jest liczbą całkowitą i nieujemną?
all(agencja$stories %% 1 == 0) && all(agencja$stories >= 0)
#sprwdzenie czy liczba miejsc parkingowych jest liczbą całkowitą i nieujemną
all(agencja$parking %% 1 == 0) && all(agencja$parking >= 0)
#sprawdzenie czy wszystkie wartości w kolumnie Mainroad to "Tak" lub "Nie"
all(agencja$mainroad %in% c("yes", "no"))
#sprawdzenie czy wszystkie wartości w kolumnie Guestroom to "Tak" lub "Nie"
all(agencja$guestroom %in% c("yes", "no"))
#sprawdzenie czy wszystkie wartości w kolumnie Basement to "Tak" lub "Nie"
all(agencja$basement %in% c("yes", "no"))
#sprawdzenie czy wszystkie wartości w kolumnie Hot water heating to "Tak" lub "Nie"
all(agencja$hotwaterheating %in% c("yes", "no"))
#sprawdzenie czy wszystkie wartości w kolumnie Airconditioning to "Tak" lub "Nie"
all(agencja$airconditioning %in% c("yes", "no"))
#sprawdzenie czy Furnishing status zawiera tylko dopuszczalne wartości?
all(agencja$`Furnishing status` %in% c("w pełni umeblowany", "częściowo umeblowany", "nieumeblowany"))
#sprawdzenie czy Prefarea zawiera tylko "Tak" lub "Nie"?
all(agencja$Prefarea %in% c("yes", "no"))
```

Podczas analizy danych o nieruchomościach stwierdzono, że wszystkie kluczowe warunki walidacyjne zostały spełnione. Cena nieruchomości oraz powierzchniajest przechowywana jako liczba, a liczba sypialni, łazienek, pięter oraz miejsc parkingowych zawiera tylko nieujemne liczby całkowite. Dodatkowo, kolumny Mainroad, Guestroom, Basement, Hot water heating, Airconditioning, Furnishing status i Prefarea zawierają tylko oczekiwane wartości 'Tak' lub 'Nie'. Dane są gotowe do dalszej analizy.

## Wizualizacja danych

#############################################DODAĆ OPIS#######################################################

### Wykresy zmiennej ilościowej

Histogram cen nieruchomości z podziałem na liczebność sypialni

```{r}
library(ggplot2)
ggplot(agencja, aes(x = price , fill = factor(bedrooms))) +
  geom_histogram(binwidth = 2000000, position = "dodge", color = "black", alpha = 0.7) +
  labs(title = "Histogram cen nieruchomości z podziałem na liczebność sypialni",
       x = "Cena",
       y = "Liczba nieruchomości") +
  scale_fill_discrete(name = "Liczba sypialni")
```
Histogram pokazuje rozkład cen nieruchomości w zależności od liczby sypialni. Najczęstszym typem nieruchomości są te z trzema sypialniami, które mają średnią cenę około 4000000. Nieruchomości z dwoma sypialniami są zwykle tańsze, a z czterema droższe. Nieruchomości z jedną, pięcioma lub sześcioma sypialniami są rzadkie na rynku.

```{r}
ggplot(agencja, aes(x = price, fill = factor(bedrooms))) +
  geom_density(alpha = 0.25) +
  labs(title = 'Gęstość rozkładu cen', x = 'Cena', y = 'Gęstość') +
  scale_fill_discrete(name = 'Liczba sypialni')
```
Wykres przedstawia gęstość rozkładu cen nieruchomości w zależności od liczby sypialni. Wykres pokazuje, że im więcej sypialni ma nieruchomość, tym bardziej zróżnicowane są jej ceny. Nieruchomości z jedną sypialnią mają najwyższą gęstość cenową wokół 8.0e+06, co oznacza, że większość z nich ma podobną cenę. Nieruchomości z większą liczbą sypialni mają niższe i szersze szczyty gęstości, co oznacza, że ich ceny są bardziej rozproszone i zależą od innych czynników, takich jak lokalizacja, stan czy wyposażenie.

### Wykresy dwóch zmiennych ilościowych

```{r}
ggplot(agencja, aes(x = area, y = price, color = factor(bedrooms))) +
  geom_point() +
  labs(title = 'Wykres punktowy: Cena vs. Powierzchnia',
       x = 'Powierzchnia',
       y = 'Cena') +
  scale_color_discrete(name = 'Liczba sypialni')
```
Wykres przedstawia związek między ceną a powierzchnią nieruchomości, z podziałem na liczbę sypialni. Wykres pokazuje, że ogólnie rzecz biorąc, im większa jest powierzchnia, tym wyższa jest cena, ale istnieje duża zmienność, co wskazuje na wpływ innych czynników na cenę. Różne kolory oznaczają nieruchomości z różną liczbą sypialni, jednak nie widać wyraźnego wzorca, który by wskazywał, że liczba sypialni ma znaczący wpływ na cenę.

### Wykresy zmiennej jakościowej

```{r}
```

### Wykresy dwóch zmiennych jakościowych

```{r}
```

### Wykresy zmiennej ilościowej vs zmiennej jakościowej

```{r}
library(dplyr)
medians <- agencja %>%
  group_by(bedrooms) %>%
  dplyr::summarize(median_price = median(price, na.rm = TRUE)) 
ggplot(agencja, aes(x = factor(bedrooms), y = price)) +
  geom_boxplot(aes(fill = factor(bedrooms)), outlier.alpha = 0.25, position = 'dodge') +
  geom_text(data = medians, aes(x = factor(bedrooms), y = median_price, label = median_price),
            color = 'red', hjust = -0.5, vjust = 0.5, size = 3) +
  stat_summary(aes(ymax = after_stat(y), ymin = after_stat(y)), fun = mean,
               geom = 'errorbar', width = 0.75, linetype = 'solid',
               position = 'dodge', color = 'white', size = 1) +
  theme(legend.position = 'none')
```
Wykres przedstawia zależność między ceną domu a liczbą sypialni. Z wykresu wynika, że im więcej sypialni ma dom, tym jest droższy. Jednak w kategoriach 2, 3 i 4 sypialni występują wartości odstające, które zwiększają zmienność cen. Największa różnica cenowa jest między domami z 4 i 5 sypialniami, co widać po długich wąsach wykresów pudełkowych. Domy z 6 sypialniami nie pasują do ogólnej tendencji, ponieważ są tańsze niż domy z mniejszą liczbą sypialni.

### Wykresy bąbelkowe

```{r}
```

### Kilka wykresów na jednym panelu

```{r}
```


## Analiza opisowa

#############################################DODAĆ OPIS#######################################################


### Data wrangling

```{r}
```

### Tabele liczności oraz TAI

```{r}
```

### Podstawowe wykresy

```{r}
```

### Grupowanie grafik

```{r}
```

### Statystyki opisowe

```{r}
```

### Podsumowanie opisu danych

```{r}
```

### Macierze korelacji

```{r}
library(corrplot)
corrplot(cor(agencja[,1:5,11]), method = "number", type = "upper", diag =FALSE)
corr_matrix<-cor(agencja[,1:5,11])
corrplot(corr_matrix, method="color")
```

## Wnioskowanie statystyczne

#############################################DODAĆ OPIS#######################################################



