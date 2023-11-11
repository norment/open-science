import sys

print(sys.argv)

REFFILE=sys.argv[1]
TRAITFILE=sys.argv[2]
TRAITNAME1=sys.argv[3]
TRAITFILES=sys.argv[4]
TRAITNAMES=sys.argv[5]
TRAITFOLDER=sys.argv[6]
REFINFO=sys.argv[7]

s = open('config.txt').read()

s = s.replace('reffile=ref9545380_1kgPhase3eur_LDr2p1.mat','reffile=' + REFFILE)
s = s.replace('traitfile1=CTG_COG_2018.mat','traitfile1=' + TRAITFILE)
s = s.replace('traitname1=COG','traitname1=' + TRAITNAME1)
s = s.replace('traitfiles={\'SSGAC_EDU_2016.mat\'}','traitfiles={\'' + TRAITFILES + '\'}')
s = s.replace('traitnames={\'EDU\'}','traitnames={\'' + TRAITNAMES + '\'}')
s = s.replace('traitfolder=.','traitfolder=' + TRAITFOLDER)
s = s.replace('refinfo=','refinfo=' + REFINFO)
s = s.replace('onscreen = true','onscreen = false')
#s = s.replace('randprune_n=20','randprune_n=500')

file = open('config.txt','w')
file.write(s)
file.close()


