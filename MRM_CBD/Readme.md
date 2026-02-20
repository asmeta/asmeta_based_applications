## AsmetaComp: a Tool for Runtime Contract Checking with I/O Abstract State Machines
### Silvia Bonfanti, Angelo Gargantini, Elvinia Riccobene, Patrizia Scandurra

This folder contains the tool software artifacts (including models and the scenarios of the Medicine Reminder 
and Monitoring (MRM) System) for the paper "AsmetaComp: a Tool for Runtime Contract Checking with I/O Abstract State Machines"
submitted at FORTE 2026 - 46th International Conference on Formal Techniques for Distributed Objects, Components, and Systems.

The MRM system is designed to control a smart medicine dispenser 
(a remotely controllable pillbox) for medicine administration.

To test the models and the contracts, we have introduced the following scenarios:


## Validation Scenarios

| **Scenario** | **Error**       | Expected violated contract  |  **Description**                                                                 |
|--------------|-----------------|---------------------------------|---------------------------------------------------------------------------------|
| CS1          | none            | --                              | A pill is missed, and successfully rescheduled.          |
| CS2          | none            | --                              | The first pill is taken on time, and the second is rescheduled and taken at the new time. |
| CS3          | none            | --                              | The pills are taken at the prescribed time. |
| WP           | Wrong pill      | `inv_A_medicineList`           | The patient loads an incorrect medicine in the second compartment.             |
| PO           | Pill overlap    | `inv_A_timeConsumption`        | The rescheduler sets a new time consumption that violates the minimum interval before the next dose. |
| WC           | Wrong configuration    | `inv_A_timeConsumption`        | The physician prescribes medicine without adhering to the minimum interval between medicines. |



The scripts to simulate the scenarios presented in the paper are in the folder "MRMModels":
- CS1: pillboxCompCS1.asmsh
- CS2: pillboxCompCS2.asmsh
- CS3: pillboxCompCS3.asmsh
- WP: pillboxCompWP.asmsh
- PO: pillboxCompPO.asmsh
- WC: pillboxCompWC.asmsh

Download the *AsmetaComp.jar* file along with the models located in the MRMModels folder.

To run the scenarios and check the simulation, run the *AsmetaComp* using the following command in "MRM_CBD" folder:

```
java -jar AsmetaComp.jar MRMModels/"filename".asmsh
```
