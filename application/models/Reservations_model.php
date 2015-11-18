<?php if ( ! defined('BASEPATH')) exit('No direct script access allowed');
class Reservations_model extends CI_Model {

    function __construct()
    {
        // Call the Model constructor
        parent::__construct();
    }

    public function reservations_get_supervision_slots($start_time, $end_time) 
    {
        $sql = "SELECT * FROM Supervision WHERE StartTime > STR_TO_DATE(?,'%Y-%m-%d %H:%i:%s') AND 
                      EndTime < STR_TO_DATE(?,'%Y-%m-%d %H:%i:%s')";
        return $this->db->query($sql, array($start_time, $end_time));

    }

    public function reservations_get_reserved_slots($start_time, $end_time, $machine) 
    {
        $sql = "SELECT * FROM Reservation WHERE StartTime <= STR_TO_DATE(?,'%Y-%m-%d %H:%i:%s') AND 
                      EndTime >= STR_TO_DATE(?,'%Y-%m-%d %H:%i:%s') AND MachineID=? ORDER BY StartTime ASC";
        $response = $this->db->query($sql, array($end_time, $start_time, $machine));
        return $response->result();
    }


    public function reservations_get_all_reserved_slots($start_time, $end_time) 
    {
        $sql = "SELECT * FROM Reservation WHERE StartTime > STR_TO_DATE(?,'%Y-%m-%d %H:%i:%s') AND 
                      EndTime < STR_TO_DATE(?,'%Y-%m-%d %H:%i:%s')";
        $response = $this->db->query($sql, array($start_time, $end_time));
        return $response->result();
    }

    public function reservations_get_supervisor_levels($supervisor_id, $machine_id=false)
    {
        $this->db->select('*');
        $this->db->from('UserLevel');
        $this->db->where('Aauth_usersID', $supervisor_id);
        $this->db->where('Level > 3');
        if ($machine_id) {$this->db->where('MachineID', $machine_id);};
        return $this->db->get();
    }

    public function reservations_get_group_machines($group_id=false)
    {
        
        $this->db->select('MachineID, Manufacturer, Model, NeedSupervision');
        $this->db->from('Machine');
        $this->db->where('active', 1);
        if ($group_id) {
            $this->db->where('MachineGroupID', $group_id);
        }
        return $this->db->get();
    }

    public function reservations_get_machines()
    {
        $this->db->select('MachineGroupID, Name');
        $this->db->from('MachineGroup');
        $this->db->where('active', 1);
        $groups = $this->db->get();
        $response = array();
        if ($groups->num_rows() > 0) {
            foreach($groups->result() as $group)
            {
                $group_array = array(
                    "id" => "cat_" . $group->MachineGroupID,
                    "title" => $group->Name,
                    "children" => array()
                );
                $machines = $this->reservations_get_group_machines($group->MachineGroupID);
                if ($machines->num_rows() > 0)
                {
                    foreach($machines->result() as $machine)
                    {
                        $group_array['children'][] = array(
                            "id" => "mac_" . $machine->MachineID,
                            "title" => $machine->Manufacturer . " " . $machine->Model
                        );
                    }
                    $response[] = $group_array;
                }
            }
        }
        return $response;
    }
    public function set_new_reservation($data) {
    	$this->db->insert('Reservation', $data);
    }
    public function get_user_level($user_id = false, $machine_id = false)
    {
    	$this->db->select('*');
    	$this->db->from('UserLevel');
    	if ($user_id != false)
    	{
    		$this->db->where('aauth_usersID', $user_id);
    	}
    	if ($machine_id != false)
    	{
    		$this->db->where('MachineID', $machine_id);
    	}
    	return $this->db->get();
    }
}