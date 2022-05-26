This cookbook uses Test Kitchen and InSpec for cookbook testing.

First set a registration token in the `MONDOO_TOKEN` env var. Then run the Test Kitchen tests:

```bash
# show all test vms 
kitchen list
# converge all vms
kitchen converge
# converge an individual vm
kitchen converge centos
# verify all instances
kitchen verify
# debug instance
kitchen login centos
# destroys all instances
kitchen destroy
```
