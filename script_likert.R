setwd("D:\\r ladies online\\Likert\\Fun Survey R-Ladies Jakarta & Bogor.csv")

#baca dataset
#read the dataset
ds<-read.csv("res2.csv")

#install packages dan panggil ke environment kerja
#install packages and call to the environment
install.packages("likert")
install.packages("plyr")
install.packages("vtable")
library(likert)
library(plyr)
library(vtable)

#Overview data, set as factors
ds$jenis.kelamin<-as.factor(ds$jenis.kelamin)
ds$range_umur<-as.factor(ds$range_umur)
ds$aktivitas.sehari.hari<-as.factor(ds$aktivitas.sehari.hari)

vtable(ds, index=T)

#Untuk ke 7 pertanyaan, tetapkan terlebih dahulu level kategori jawaban
#For the 7 questions, prepare the order and list of levels 
#of the answer categories

ds$q1 <-
  factor(ds$q1,
         levels=c("Sangat tidak setuju",
                  "Tidak setuju",
                  "Netral",
                  "Setuju",
                  "Sangat setuju"))

ds$q2 <-
  factor(ds$q2,
         levels=c("Sangat tidak setuju",
                  "Tidak setuju",
                  "Netral",
                  "Setuju",
                  "Sangat setuju"))

ds$q3 <-
  factor(ds$q3,
         levels=c("Sangat tidak setuju",
                  "Tidak setuju",
                  "Netral",
                  "Setuju",
                  "Sangat setuju"))

ds$q4 <-
  factor(ds$q4,
         levels=c("Sangat tidak setuju",
                  "Tidak setuju",
                  "Netral",
                  "Setuju",
                  "Sangat setuju"))

ds$q5 <-
  factor(ds$q5,
         levels=c("Sangat tidak setuju",
                  "Tidak setuju",
                  "Netral",
                  "Setuju",
                  "Sangat setuju"))

ds$q6 <-
  factor(ds$q6,
         levels=c("Sangat tidak setuju",
                  "Tidak setuju",
                  "Netral",
                  "Setuju",
                  "Sangat setuju"))

ds$q7 <-
  factor(ds$q7,
         levels=c("Sangat tidak setuju",
                  "Tidak setuju",
                  "Netral",
                  "Setuju",
                  "Sangat setuju"))

#Subset q1-q7 for the likert viz
for.lik<-ds[,c(5:11)] 

#Rename q1-q7 to the real questions
names(for.lik)<-c("1. Saya paling suka memakai Whatsapp untuk text messaging",
                  "2. Saya paling suka memakai Telegram untuk text messaging",
                  "3. Saya paling suka memakai aplikasi selain Whatsapp/Telegram untuk text messaging",
                  "4. Saya menghabiskan waktu paling banyak memakai aplikasi Facebook",
                  "5. Saya menghabiskan waktu paling banyak memakai aplikasi Instagram",
                  "6. Saya menghabiskan waktu paling banyak memakai aplikasi Twitter",
                  "7. Saya menghabiskan waktu paling banyak memakai aplikasi TikTok")

#Run the likert function to calculate data summary for each question

res.lik<-likert(for.lik)
summary(res.lik)

res.lik$items

#Plot using barplot
plot(res.lik,
     type="bar",
     group.order = names(for.lik))

#Plot with heatmap
plot(res.lik,
     type="heat",
     low.color = "white",
     high.color = "blue",
     text.color = "black",
     text.size = 4,
     wrap = 50,
     group.order=names(for.lik))

#mean (SD) = data terbagi menjadi data "high" dan "low"
#semakin tinggi nilai mean menunjukkan proporsi data banyak
#pada bagian "high" dalam hal ini ">Netral"

#Plot with histogram
plot(res.lik,
     type="density",
     facet = TRUE,
     bw = 0.5,
     group.order=names(for.lik))

#Let's differentiate by different categories

#rename all column title
names(ds)<-c("Jenis kelamin",
             "Umur",
             "Rentang umur",
             "Aktivitas sehari-hari",
             "1. Saya paling suka memakai Whatsapp untuk text messaging",
             "2. Saya paling suka memakai Telegram untuk text messaging",
             "3. Saya paling suka memakai aplikasi selain Whatsapp/Telegram untuk text messaging",
             "4. Saya menghabiskan waktu paling banyak memakai aplikasi Facebook",
             "5. Saya menghabiskan waktu paling banyak memakai aplikasi Instagram",
             "6. Saya menghabiskan waktu paling banyak memakai aplikasi Twitter",
             "7. Saya menghabiskan waktu paling banyak memakai aplikasi TikTok")

#drop NAs
ds3<-ds %>% 
  drop_na()

#Group by age range
res.lik2 <- likert(items=ds3[,5:11], grouping=ds3[,3])
plot(res.lik2)

#Group by daily activities
res.lik3 <- likert(items=ds3[,5:11], grouping=ds3[,4])
plot(res.lik3)

#Group by gender
res.lik4 <- likert(items=ds3[,5:11], grouping=ds3[,1])
plot(res.lik4)

#################### with ggplot ############################

# additional package requirements
install.packages("ggplot2")
install.packages("reshape2")
install.packages("RColorBrewer")
install.packages("plyr")
library(ggplot2)
library(reshape2)
library(RColorBrewer)
library(plyr)

# some defaults
ymin = 0
text.size = 3

# create summary table
table_summary = summary(res.lik)

# reshape results
results = melt(res.lik$results, id.vars='Item')

#plot
ggplot(results, aes(y=value, x=Item, group=Item)) + 
  geom_bar(stat='identity', aes(fill=variable)) + 
  ylim(c(-5,105)) + 
  coord_flip() +
  scale_fill_manual('Response', values=brewer.pal(7, "RdYlGn"), 
                    breaks=levels(results$variable), 
                    labels=levels(results$variable)) +
  geom_text(data=table_summary, y=ymin, aes(x=Item, 
                                                    label=paste(round(low), '%', sep='')), 
            size=text.size, hjust=1) +
  geom_text(data=table_summary, y=100, aes(x=Item,
                                                   label=paste(round(high), '%', sep='')), 
            size=text.size, hjust=-.2) +
  ylab('Percentage') + xlab('')

#References
#https://rpubs.com/m_dev/likert_summary
#https://cran.r-project.org/web/packages/likert/likert.pdf
#https://stackoverflow.com/questions/48340901/using-likert-package-in-r-for-analyzing-real-survey-data
#https://stackoverflow.com/questions/14415674/reordering-groups-in-likert-plots-with-r
#https://rcompanion.org/handbook/E_03.html
#https://rcompanion.org/handbook/E_01.html