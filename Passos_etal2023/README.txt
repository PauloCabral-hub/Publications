The folder contains the following files:

1 - "ParticipantInfo.csv"
2 - "GameInfo.csv"
3 - "bic_mixture1D.m"

These files have all the information necessary to reproduce the results of the article "WHAT COMES NEXT? RESPONSE TIME IS AFFECTED BY MISPREDICTION IN A STOCHASTIC GAME" by the authors Paulo Roberto Cabral-Passos, Jesus Enrique Garcia, Antonio Galves and Claudia Vargas. 

The participants were anonymized. 

____________________________________________________________________________

The file "ParticipantInfo.csv" contains a column table organized in the following way: 

<Id> = Integer number used for participant identification in the dataset.

<Age> = Participant's age.

<Gender> = Participant's gender.

<Handedness> = Participant's handedness.

<FirstPause> = Duration of the first pause in the experimental protocol.

<SecondPause> = Duration of the second pause in the experimental protocol.

____________________________________________________________________________

The file "GameInfo.csv" contains a column table organized in the following way: 

<Id> = Integer number used for participant identification in the dataset. The same number used in "ParticipantInfo.csv". This number is repeated each row to match the number of trials played by the participant.

<TrialNumber> =  Integer number used to identify the trial of a given participant indicated in Id.

<PenaltyTakerChoice> = Choice of the penalty taker in a given trial indicated in TrialNumber for the participant indicated in Id. 0 idicates left, 1 indicates center and 2 indicates right.

<GoalkeeperChoice> = Choice of the goalkeeper in a given trial indicated in TrialNumber for the participant indicated in Id. 0 idicates left, 1 indicates center and 2 indicates right.

<ResponseTime> = Response time, in seconds, of the goalkeeper in a given trial indicated in TrialNumber for the participant indicated in Id.
____________________________________________________________________________

The file "bic_mixture1D.m" contains a matlab function to compute the gaussian mixture models described in the article. Comments have been added.

for more information: please contact paulorcpassos@gmail.com

