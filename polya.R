library(tidyverse)

### polya's urn simulation

sim <- function(w,b,c, time=1000){
  p <- b/(w+b)
  log <- tibble(t=0,w=w,b=b,p=p)
  for (t in 1:time){
    samp <- sample(c("black","white"),size=1,replace=FALSE,prob=c(log$p[t],1-log$p[t]))
    
    if (samp=="black"){
      new_b <- log$b[t]+c
      new_w <- log$w[t]
      log <- add_row(log, t=t,w=new_w,b=new_b, p=new_b/(new_b+new_w))
    } else if(samp=="white")
      {
        
        new_b <- log$b[t]
        new_w <- log$w[t]+c
        log <- add_row(log, t=t,w=new_w,b=new_b, p=new_b/(new_b+new_w))

    }else errorCondition("error")
  }
  log
}


sims <- function(nsims, w,b,c, time=1000){
  logs <- tibble(t=rep(0:time,nsims),sim=factor(rep(1:nsims,each=time+1)),p=NA)
  for (i in 1:nsims){
    sim <- sim(w,b,c,time)
    logs$p[(((i-1)*time)+i):(i*(time+1))] <- sim$p
  }
  logs
}

logs <- sims(100,100,1,1, time=250)
vg <- logs |> pivot_wider(names_from=sim,values_from = p) |> rowwise() |>  mutate(mean=mean(c_across(-t))) |> select(t, "p"=mean)


logs |> ggplot() + aes(x=t, y=p)+
  geom_line(aes(group=sim), alpha=0.2)+
  geom_line(data=avg, col="red", linewidth=0.5)+
  geom_hline(yintercept=1/101)
