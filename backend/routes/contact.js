const express = require('express');
const router = express.Router();
const {createContact,getAllContacts,getContactById,updateContact,deleteContact,importContacts,exportContacts,mergeDuplicatesByPhone} = require('../controllers/contact');

// Routes for CRUD operations on contacts
router.post('/create/contact', createContact);                
router.get('/get/all-contacts/:_id', getAllContacts);                   
// router.get('/:id', getContactById);             
router.put('/:id', updateContact);              
router.delete('/:id', deleteContact);           

// Routes for VCF file handling
router.post('/import', importContacts);  
router.get('/export', exportContacts);     

// Route for merging duplicate contacts by phone number
router.post('/merge', mergeDuplicatesByPhone); 

module.exports = router;
