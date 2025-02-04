\name{seqFitNullGLMM_SPA}
\alias{seqFitNullGLMM_SPA}
\title{Fit the null model with GRM}
\description{
    Fit the null model in the mixed frame with genetic relationship matrix (GRM).
}

\usage{
seqFitNullGLMM_SPA(formula, data, gdsfile, trait.type=c("binary", "quantitative"),
    sample.col="sample.id", maf=0.005, missing.rate=0.01, max.num.snp=1000000L,
    variant.id=NULL, inv.norm=TRUE, X.transform=TRUE, tol=0.02, maxiter=20L,
    nrun=30L, tolPCG=1e-5, maxiterPCG=500L, num.marker=30L, tau.init=c(0,0),
    traceCVcutoff=0.0025, ratioCVcutoff=0.001, geno.sparse=TRUE, num.thread=1L,
    model.savefn="", seed=200L, no.fork.loading=FALSE, verbose=TRUE)
}

\arguments{
    \item{formula}{an object of class \code{formula} (or one that can be coerced to
          that class), e.g., \code{y ~ x1 + x2}, see \code{\link{lm}}}
    \item{data}{a data frame for the formulas}
    \item{gdsfile}{a SeqArray GDS filename, or a GDS object}
    \item{trait.type}{"binary" for binary outcomes, "quantitative" for continuous
        outcomes (not applicable)}
    \item{sample.col}{the column name of sample IDs corresponding to the GDS file}
    \item{maf}{minor allele frequency for imported genotypes, if \code{variant.id=NULL}}
    \item{missing.rate}{threshold of missing rate, if \code{variant.id=NULL}}
    \item{max.num.snp}{the maximum number of SNPs used, or -1 for no limit}
    \item{variant.id}{a list of variant IDs, used to construct GRM}
    \item{inv.norm}{perform inverse normal transform or not}
    \item{X.transform}{if TRUE, perform QR decomposition on the design matrix}
    \item{tol}{overall tolerance for model fitting}
    \item{maxiter}{the maximum number of iterations for model fitting}
    \item{nrun}{the number of random vectors in the trace estimation}
    \item{tolPCG}{tolerance of PCG iterations}
    \item{maxiterPCG}{the maximum number of PCG iterations}
    \item{num.marker}{the number of SNPs used to calculate the variance ratio}
    \item{tau.init}{a 2-length numeric vector, the initial values for variance components,
        tau; for binary traits, the first element is always be set to 1.
        if \code{tau.init} is not specified, the second element will be 0.5 for binary
        traits}
    \item{traceCVcutoff}{the threshold for coefficient of variation (CV) for the trace
        estimator, and the number of runs for trace estimation will be increased until
        the CV is below the threshold}
    \item{ratioCVcutoff}{the threshold for coefficient of variation (CV) for estimating
        the variance ratio, and the number of randomly selected markers will be increased
        until the CV is below the threshold}
    \item{geno.sparse}{if TRUE, store the sparse structure for genotypes; otherwise, save
        genotypes in a 2-bit dense matrix; see details}
    \item{num.thread}{the number of threads}
    \item{model.savefn}{the filename of model output, R data file '.rda' or '.RData'}
    \item{seed}{an integer as a seed for random numbers}
    \item{no.fork.loading}{forking processes in Unix can reduce loading time, but may
        double the memory usage; not applicable on Windows}
    \item{verbose}{if \code{TRUE}, show information}
}

\details{
    Utilizing the sparse structure of genotypes could significantly improve the
computational efficiency of model fitting, but it also increases the memory usage.
    For more details of SAIGE algorithm, please refer to the SAIGE paper.
}

\value{
    Returns a list with the following components:
    \code{coefficients}, the beta coefficients for fixed effects;
    \code{tau}, a numeric vector of variance components 'Sigma_E' and 'Sigma_G';
    \code{linear.predictors}, the linear fit on link scale;
    \code{fitted.values}, fitted values from objects returned by modeling functions using
        \code{glm.fit};
    \code{residuals}, residuals;
    \code{cov}, covariance matrix of beta coefficients;
    \code{converged}, whether the model is fitted or not;
    \code{obj.noK}, internal use, returned object from the SPAtest package;
    \code{var.ratio}, a data.frame with columns 'id' (variant.id), 'maf' (minor allele
        frequency), 'var1' (the variance of score statistic), 'var2' (a variance estimate
        without accounting for estimated random effects) and 'ratio' (var1/var2,
        estimated variance ratio for variance approximation);
    \code{trait.type}, either "binary" or "quantitative";
    \code{sample.id}, the sample IDs used in the model fitting;
    \code{variant.id}, the variant IDs used in the model fitting.
}

\references{
    Zhou W, Nielsen JB, Fritsche LG, Dey R, Gabrielsen ME, Wolford BN, LeFaive J,
    VandeHaar P, Gagliano SA, Gifford A, Bastarache LA, Wei WQ, Denny JC, Lin M, Hveem K,
    Kang HM, Abecasis GR, Willer CJ, Lee S.
    Efficiently controlling for case-control imbalance and sample relatedness in
    large-scale genetic association studies.
    Nat Genet (2018). Sep;50(9):1335-1341.
}
\author{Xiuwen Zheng}
\seealso{
    \code{\link{seqAssocGLMM_SPA}}
}

\examples{
# open a GDS file
fn <- system.file("extdata/grm1k_10k_snp.gds", package="SAIGEgds")
gdsfile <- seqOpen(fn)

# load phenotype
phenofn <- system.file("extdata/pheno.txt.gz", package="SAIGEgds")
pheno <- read.table(phenofn, head=TRUE, as.is=TRUE)

# fit the null model
glmm <- seqFitNullGLMM_SPA(y ~ x1 + x2, pheno, gdsfile)


# close the GDS file
seqClose(gdsfile)
}

\keyword{GDS}
\keyword{genetics}
\keyword{association}
