const Contact = require('../models/contact');
const fs = require('fs');
const vcf = require('vcf');

exports.createContact = async (req, res) => {
    const { firstName, lastName, email, phone, tags, userId } = req.body;
    try {
        const newContact = new Contact({
            userId,
            firstName,
            lastName,
            email,
            phone,
            tags
        });
        const savedContact = await newContact.save();
        res.status(201).json(savedContact);
    } catch (error) {
        res.status(400).json({ message: 'Failed to create contact', error });
    }
};

exports.getAllContacts = async (req, res) => {
    const userId = req.params;
    try {
        const contacts = await Contact.find({ userId });
        res.json(contacts);
    } catch (error) {
        res.status(500).json({ message: 'Failed to retrieve contacts' });
    }
};

exports.updateContact = async (req, res) => {
    const { contactId } = req.params;
    const { firstName, lastName, email, phone, tags } = req.body;
    const userId = req.user.userId;
    try {
        const updatedContact = await Contact.findOneAndUpdate(
            { _id: contactId, userId },  // Ensure the contact belongs to the logged-in user
            { firstName, lastName, email, phone, tags },
            { new: true }
        );
        if (!updatedContact) {
            return res.status(404).json({ message: 'Contact not found' });
        }
        res.res(200).json(updatedContact);
    } catch (error) {
        res.status(400).json({ message: 'Failed to update contact', error });
    }
};

exports.deleteContact = async (req, res) => {
    const { contactId } = req.params;
    const userId = req.user.userId;
    try {
        const deletedContact = await Contact.findOneAndDelete({ _id: contactId, userId });
        if (!deletedContact) {
            return res.status(404).json({ message: 'Contact not found' });
        }
        res.json({ message: 'Contact deleted successfully' });
    } catch (error) {
        res.status(500).json({ message: 'Failed to delete contact' });
    }
};

exports.importContacts = async (req, res) => {
    const userId = req.user.userId;
    const vcfFile = req.files.contacts;
    try {
        const vcfData = fs.readFileSync(vcfFile.tempFilePath, 'utf-8');
        const parsedVCF = new vcf().parse(vcfData);
        const contactsToSave = parsedVCF.contacts.map(contact => ({
            userId,
            firstName: contact.fn || '',
            email: contact.email || '',
            phone: contact.tel || ''
        }));
        const savedContacts = await Contact.insertMany(contactsToSave);
        res.json({ message: 'Contacts imported successfully', savedContacts });
    } catch (error) {
        res.status(400).json({ message: 'Failed to import contacts', error });
    }
};

exports.exportContacts = async (req, res) => {
    const userId = req.user.userId;
    try {
        const contacts = await Contact.find({ userId });
        const vcfFile = new vcf();
        contacts.forEach(contact => {
            vcfFile.addContact({
                fn: `${contact.firstName} ${contact.lastName}`,
                email: contact.email,
                tel: contact.phone
            });
        });
        const vcfData = vcfFile.toString();
        res.setHeader('Content-Type', 'text/vcard');
        res.setHeader('Content-Disposition', 'attachment; filename="contacts.vcf"');
        res.send(vcfData);
    } catch (error) {
        res.status(500).json({ message: 'Failed to export contacts', error });
    }
};

exports.mergeDuplicatesByPhone = async (req, res) => {
    const userId = req.user.userId;
    try {
        const duplicates = await Contact.aggregate([
            { $match: { userId } }, 
            {
                $group: {
                    _id: "$phone",       
                    contacts: { $push: "$$ROOT" },
                    count: { $sum: 1 }  
                }
            },
            { $match: { count: { $gt: 1 } } } 
        ]);

        const mergedContacts = [];
        for (let group of duplicates) {
            const contacts = group.contacts;
            const primaryContact = contacts[0];
            for (let i = 1; i < contacts.length; i++) {
                const duplicateContact = contacts[i];
                if (!primaryContact.firstName && duplicateContact.firstName) {
                    primaryContact.firstName = duplicateContact.firstName;
                }
                if (!primaryContact.lastName && duplicateContact.lastName) {
                    primaryContact.lastName = duplicateContact.lastName;
                }
                if (!primaryContact.email && duplicateContact.email) {
                    primaryContact.email = duplicateContact.email;
                }
                const newTags = [...new Set([...primaryContact.tags, ...duplicateContact.tags])];
                primaryContact.tags = newTags;
                await Contact.findByIdAndDelete(duplicateContact._id);
            }
            
            const updatedContact = await Contact.findByIdAndUpdate(primaryContact._id, primaryContact, { new: true });
            mergedContacts.push(updatedContact);
        }
        res.res(200).json({ message: 'Contacts merged successfully', mergedContacts });
    } catch (error) {
        res.status(500).json({ message: 'Failed to merge contacts', error });
    }
};





