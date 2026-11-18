## AsmetaComp: a Tool for Runtime Contract Checking with I/O Abstract State Machines
### Silvia Bonfanti, Angelo Gargantini, Elvinia Riccobene, Patrizia Scandurra

This folder contains the tool software artifacts (including models and the scenarios of the Medicine Reminder 
and Monitoring (MRM) System) for the tool paper "AsmetaComp: a Tool for Runtime Contract Checking with I/O Abstract State Machines"
accepted for presentation at FORTE 2026 - 46th International Conference on Formal Techniques for Distributed Objects, Components, and Systems.


## Additional Material
In this repository, we provide the following additional material:
* [Soundness Proofs for the Contract Composition Rules of I/O ASM](https://github.com/asmeta/asmeta_based_applications/blob/main/MRM_CBD/Soundness%20Proofs%20for%20the%20Contract%20Composition%20Rules%20of%20IO%20ASM.pdf)
* [Tool Artifact Description](https://github.com/asmeta/asmeta_based_applications/blob/main/MRM_CBD/Tool%20Artifact%20Description.pdf) for the MRM System Validation Scenarios execution


## MRM System Validation
The MRM system is designed to control a smart medicine dispenser (a remotely controllable pillbox) for medicine administration.

To test the models and the contracts, we have introduced the following scenarios:


## Validation Scenarios

| **Scenario** | **Error**                 | **Expected violated contract** |  **Scenario description**                                                                                              |
|--------------|---------------------------|--------------------------------|---------------------------------------------------------------------------------------------------------------|
| CS1          | none                      | --                             | A pill is missed, and not rescheduled since it interferes with the next pill.                                 |
| CS2          | none                      | --                             | The first pill is taken on time, and the second is rescheduled and taken at the new time.                     |
| CS3          | none                      | --                             | The pills are taken at the prescribed time.                                                                   |
| WP           | Wrong pill                | `inv_A_medicineList`           | The patient loads an incorrect pill in the second compartment.                                                |
| PO           | Pill overlap              | `inv_A_timeConsumption`        | The rescheduler sets a new time consumption that violates the minimum interval before the next dose.          |
| WC           | Wrong configuration       | `inv_A_timeConsumption`        | The physician prescribes medicine without adhering to the minimum interval between medicines.                 |
| DM           | Duplicate medicine        | `inv_A_compName`               | Both compartments contain the same medicine instead two different medicines.                                  |
| NS           | Wrong number of slots     | `inv_A_CompSize`               | A compartment is configured with one scheduled slot instead of the two prescribed.                            |
| FD           | Faulty display            | `inv_G_compDispMess1`          | A faulty compartment displays a take message while its LED is off, despite consistent inputs.                 |
| B360         | Minimum interval boundary | --                             | Two consecutive pills are scheduled exactly at the minimum allowed intake interval.                           |
| B359         | Minimum interval breach   | `inv_A_timeConsumption`        | Two consecutive pills are scheduled one minute less than the minimum allowed intake interval.                 |
| B0           | Simultaneous intakes      | `inv_A_timeConsumption`        | Two pills are scheduled at the same time, violating the minimum allowed intake interval.                      |
| CE           | Conflicting events        | `inv_A_missedNotTaken`         | A dose is reported as missed and already recorded as taken.                                                   |
| PM           | Reschedule to a past time | `inv_G_rescheduleInFuture`	 | A missed dose is rescheduled in the past.                                                                     | 



The scripts to simulate the scenarios presented in the paper are in the folder "MRMModels":
- CS1: pillboxCompCS1.asmsh
- CS2: pillboxCompCS2.asmsh
- CS3: pillboxCompCS3.asmsh
- WP: pillboxCompWP.asmsh
- PO: pillboxCompPO.asmsh
- WC: pillboxCompWC.asmsh
- DM: composedMissingMedicine.asmsh
- NS: composedWrongCount.asmsh
- FD: composedFaultyDisplay.asmsh
- B360: composedGap360.asmsh
- B359: composedGap359.asmsh
- B0: composedGap0.asmsh
- CE: rs_ConflictingEvent.asmsh
- PM: rs_PastMoment.asmsh

Download the *AsmetaComp.jar* file along with the models located in the MRMModels folder.

To run the scenarios and check the simulation, run the *AsmetaComp* using the following command in "MRM_CBD" folder:

```
java -jar AsmetaComp.jar MRMModels/"filename".asmsh
```
