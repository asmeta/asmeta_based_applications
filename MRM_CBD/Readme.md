## Contract-based Design by I/O Abstract State Machines
### Silvia Bonfanti, Angelo Gargantini, Elvinia Riccobene, Patrizia Scandurra

This folder contains the models and the scenarios of the Medicine Reminder 
and Monitoring (MRM) System submitted at the 27th International Symposium on Formal Methods (FM 2026).
The MRM system is designed to control a smart medicine dispenser 
(a remotely controllable pillbox) for medicine administration.

To test the models and the contracts, we have introduced the following scenarios:


## Validation Scenarios

| **Scenario** | **Error**       | Expected violated contract  |  **Description**                                                                 |
|--------------|-----------------|---------------------------------|---------------------------------------------------------------------------------|
| CS1          | none            | --                              | The first pill is skipped, and the second is successfully rescheduled.          |
| CS2          | none            | --                              | The first pill is skipped, and the second is rescheduled and taken at the new time. |
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

To run the scenarios and check the simulation, run the *AsmetaComp* using the following command in "MRM_CBD" folder:

```
java -jar AsmetaComp.jar MRMModels/"filename".asmsh
```
