library(openintro)
data(COL)
load("fdicHistograms.rda")

MIDS <- br[-1] - diff(br[1:2]) / 2
BR <- list()
BR[[1]] <- seq(110, 210, 10)
BR[[2]] <- seq(115, 210, 5)
BR[[3]] <- seq(110, 210, 2)
BR[[4]] <- seq(110, 210, 1)
COUNTS <- list()
for (i in 1:4) {
  COUNTS[[i]] <- rep(0, length(BR[[i]])-1)
  for (j in 1:(length(BR[[i]])-1)) {
    these <- apply(cbind(MIDS < BR[[i]][j+1],
                         MIDS >= BR[[i]][j]),
                   1,
                   all)
    if (any(these)) {
      COUNTS[[i]][j] <- sum(counts[these])
    }
  }
}

histTemp <- function(
    BR, COUNTS, col = fadeColor(COL[1], "10"),
    border = COL[1,4], probability = FALSE,
    xlab = '', ylab = NULL,
    xlim = NULL, ylim = NULL,
    ...) {
  br <- BR
  h  <- COUNTS
  if (probability) {
    h <- h / sum(h) / diff(br)
  }
  if (is.null(ylab)) {
    ylab <- 'frequency'
    if (probability) {
      ylab <- 'probability'
    }
  }
  if (is.null(xlim)[1]) {
    xR <- range(br)
    xlim <- xR + c(-0.05, 0.05) * diff(xR)
  }
  if (is.null(ylim)[1]) {
    ylim <- range(c(0, h))
  }
  plot(-1, -1,
       xlab = xlab,
       ylab = ylab,
       xlim = xlim,
       ylim = ylim,
       type = 'n',
       ...)
  abline(h = 0)
  lines(c(br[1], br[1]), c(0, h[1]), col = border)
  for (i in 1:length(h)) {
    if (i > 1) {
      if (h[i] > h[i-1]) {
        lines(rep(br[i], 2), h[c(i - 1, i)], col = border)
      }
    }
    lines(br[i + 0:1], rep(h[i], 2), col = border)
    lines(rep(br[i + 1], 2), c(0, h[i]), col = border)
    rect(br[i], 0,
         br[i + 1], h[i],
         col = col,
         border = '#00000000')
  }
}



myPDF('fdicHistograms.pdf', 6.2, 3.3,
      mfrow = c(2, 2),
      mar = c(2.7, 1, 1, 1),
      mgp = c(1.6, 0.4, 0))
for (i in 1:4) {
  histTemp(BR[[i]],
           COUNTS[[i]],
           xlim = c(125, 210),
           axes = FALSE,
           xlab = 'height (cm)')
  lines(BR[[i]],
        c(COUNTS[[i]], 0),
        type = 's',
        col = COL[1],
        lwd = 2)
  axis(1, cex.axis = 0.9)
}
dev.off()
