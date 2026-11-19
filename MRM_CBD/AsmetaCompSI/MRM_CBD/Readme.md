## AsmetaComp: Runtime Contract Checker with I/O Abstract State Machines
### Silvia Bonfanti, Angelo Gargantini, Elvinia Riccobene, Patrizia Scandurra

This folder contains the tool software artifacts (including models and the scenarios of the Medicine Reminder and Monitoring (MRM) System) for the tool paper "AsmetaComp: Runtime Contract Checker with I/O Abstract State Machines".


## Additional Material
In this repository, we provide the following additional material:
* [Soundness Proofs for the Contract Composition Rules of I/O ASM](https://github.com/asmeta/asmeta_based_applications/blob/main/MRM_CBD/Soundness%20Proofs%20for%20the%20Contract%20Composition%20Rules%20of%20IO%20ASM.pdf)
* [Tool Artifact Description](https://github.com/asmeta/asmeta_based_applications/blob/main/MRM_CBD/Tool%20Artifact%20Description.pdf) for the MRM System Validation Scenarios execution


## MRM System Validation
The MRM system is designed to control a smart medicine dispenser (a remotely controllable pillbox) for medicine administration.

To test the models and the contracts, we have introduced the following scenarios:


## A/G Contracts

| **A/G Assertion**              | **Component**         | **Description**                                                                                                                                                                            |
|--------------------------------|-----------------------|--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| `inv_A_medicineList`           | configurationMgr.asm  | Every medicine loaded into a compartment must belong to the prescribed medicine list.                                                                                                      |
| `inv_A_timeConsumption`        | configurationMgr.asm  | The scheduled intake times must respect the minimum interval required between medicines. For consecutive doses of the same medicine, the minimum interval must also be respected.         Simultaneous intakes are allowed only when the required minimum interval is zero.                                                                                                          |
| `inv_A_compName`               | configurationMgr.asm  | Every medicine included in the prescription must be assigned to at least one compartment.                                                                                                  |
| `inv_A_compSize`               | configurationMgr.asm  | The number of scheduled intake slots in each compartment must match the prescribed number of doses for the corresponding medicine.                                                         |
| `inv_G_compDispMess1`          | compartment.asm       | Whenever the compartment display shows a message containing "Take", the corresponding LED must be ON or BLINKING.                                                                          |
| `inv_A_missedNotTaken`         | rescheduler.asm       | A dose reported as missed must not already be recorded as taken at that index. It assumes that 0 means “not taken” and that the index and the sequence of actual intake times are valid.   |
| `inv_G_rescheduleInFuture`     | rescheduler.asm       | If a missed dose is rescheduled, its new intake time must be later than the time of the rescheduling decision and must fall within the same day.                                           |


## Validation Scenarios

| **Scenario** | **Error**                 | **Expected violated contract** |  **Scenario description**                                                                                     |
|--------------|---------------------------|--------------------------------|---------------------------------------------------------------------------------------------------------------|
| CS1          | none                      | --                             | A pill is missed, and not rescheduled since it interferes with the next pill.                                 |
| CS2          | none                      | --                             | The first pill is taken on time, and the second is rescheduled and taken at the new time.                     |
| CS3          | none                      | --                             | The pills are taken at the prescribed time.                                                                   |
| WP           | Wrong pill                | `inv_A_medicineList`           | The patient loads an incorrect pill in the second compartment.                                                |
| PO           | Pill overlap              | `inv_A_timeConsumption`        | The rescheduler sets a new time consumption that violates the minimum interval before the next dose.          |
| WC           | Wrong configuration       | `inv_A_timeConsumption`        | The physician prescribes medicine without adhering to the minimum interval between medicines.                 |
| DM           | Duplicate medicine        | `inv_A_compName`               | Both compartments contain the same medicine instead of two different medicines.                                  |
| NS           | Wrong number of slots     | `inv_A_compSize`               | A compartment is configured with one scheduled slot instead of the two prescribed.                            |
| FD           | Faulty display            | `inv_G_compDispMess1`          | A faulty compartment displays a take message while its LED is off, despite consistent inputs.                 |
| B360         | Minimum interval boundary | --                             | Two consecutive pills are scheduled exactly at the minimum allowed intake interval.                           |
| B359         | Minimum interval breach   | `inv_A_timeConsumption`        | Two consecutive pills are scheduled one minute less than the minimum allowed intake interval.                 |
| B0           | Simultaneous intakes      | `inv_A_timeConsumption`        | Two pills are scheduled at the same time, violating the minimum allowed intake interval.                      |
| CE           | Conflicting events        | `inv_A_missedNotTaken`         | A dose is reported as missed and already recorded as taken.                                                   |
| PM           | Reschedule to a past time | `inv_G_rescheduleInFuture`     | A missed dose is rescheduled in the past.                                                                     | 


The following table lists the validation scenarios and the corresponding composition scripts used to simulate them.

Each `.asmsh` script defines the component composition, initializes the system state, and specifies the sequence of events and inputs required to reproduce the corresponding scenario.
The scripts used to simulate the scenarios presented in the paper are available in the MRMModels folder:

| Scenario	                                            | Simulation script (.asmsh)        |
| ------------------------------------------------------|-----------------------------------|
| CS1 - Missed dose that cannot be rescheduled          | pillboxCompCS1.asmsh              |
| CS2 - Successful rescheduling of a missed dose        | pillboxCompCS2.asmsh              |
| CS3 - Normal operation: all doses taken as prescribed | pillboxCompCS3.asmsh              |
| WP - Wrong pill loaded into a compartment             | pillboxCompWP.asmsh               |
| PO - Pill overlap caused by non-optimal rescheduling  | pillboxCompPO.asmsh               |
| WC - Wrong prescription configuration                 | pillboxCompWC.asmsh               |
| DM - Duplicate medicine assigned to compartments      | composedMissingMedicine.asmsh     |
| NS - Wrong number of scheduled intake slots           | composedWrongCount.asmsh          |
| FD - Faulty compartment display                       | composedFaultyDisplay.asmsh       |
| B360 - Minimum interval boundary (360 minutes)        | composedGap360.asmsh              |
| B359 - Minimum interval violation (359 minutes)       | composedGap359.asmsh              |
| B0 - Simultaneous intakes (0-minute interval)         | composedGap0.asmsh                |
| CE - Conflicting missed and taken events              | rs_ConflictingEvent.asmsh         |
| PM - Rescheduling a missed dose to a past time        | rs_PastMoment.asmsh               |

Download the *AsmetaComp.jar* file along with the models located in the *MRMModels* folder.

To run the scenarios and check the simulation, run the *AsmetaComp* from "MRM_CBD" folder using the following command:

```
java -jar AsmetaComp.jar MRMModels/"filename".asmsh
```
Replace "filename" with the name of the composition script corresponding to the scenario you want to execute.
