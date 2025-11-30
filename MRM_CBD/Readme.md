Contract-based Design by I/O Abstract State Machines
Silvia Bonfanti, Angelo Gargantini, Elvinia Riccobene, Patrizia Scandurra

This folder contains the models and the scenarios of the Medicine Reminder 
and Monitoring (MRM) System submitted at the 27th International Symposium on Formal Methods (FM 2026).
The MRM system is designed to control a smart medicine dispenser 
(a remotely controllable pillbox) for medicine administration.

In the paper, we have introduced four scenarios:


# Validation Scenarios

| **Scenario** | **Error**** | **Description**                                                                 |
|--------------|-----------------|---------------------------------|---------------------------------------------------------------------------------|
| CS1          | none            | --                              | The first pill is skipped and the second is successfully rescheduled.          |
| CS2          | none            | --                              | The first pill is skipped, and the second is rescheduled and taken at the new time. |
| WP           | Wrong pill      | `inv_A_medicineList`           | The patient loads an incorrect medicine in the second compartment.             |
| PO           | Pill overlap    | `inv_A_timeConsumption`        | The rescheduler sets a time that violates the minimum interval before the next dose. |



The scripts to simulate the scenarios presented in the paper are in the folder "MRMModels":
- CS1: pillboxCompCS1.asmsh
- CS2: pillboxCompCS2.asmsh
- WP: pillboxCompWP.asmsh
- PO: pillboxCompPO.asmsh

To run the scenarios, and check the simulation use the following command in "MRM_CBD" folder:

java -jar AsmetaComp.jar MRMModels/"filename".asmsh 