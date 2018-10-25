//
//  SettingsTableViewController.swift
//  Polocal
//
//  Created by Adam Eliezerov on 15/10/2018.
//  Copyright © 2018 Adam Eliezerov. All rights reserved.
//

import UIKit
import FirebaseDatabase

class SettingsTableViewController: UITableViewController {
	
	var postID = String()
	var ref: DatabaseReference!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }


	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: true)
		if indexPath.section == 0 && indexPath.row == 0 {
			
			print("user reported the post: \(self.postID)")
			let ref = Database.database().reference().child("Posts").child(UserDefaults.standard.string(forKey: "schoolSemel")!).child(self.postID).child("reportCount").child(UserDefaults.standard.string(forKey: "userID")!)
			ref.setValue(UserDefaults.standard.string(forKey: "userID")!)
			let alert = UIAlertController(title: "דיווח על השאלה", message: "אנחנו נבדוק את העניין, תודה.", preferredStyle: UIAlertControllerStyle.alert)
			alert.addAction(UIAlertAction(title: "המשך", style: UIAlertActionStyle.default, handler: nil))
			self.present(alert, animated: true, completion: nil)
		} else if indexPath.section == 1 && indexPath.row == 0 {
			tableView.deselectRow(at: indexPath, animated: true)
			print("opening on app store...")
			guard let url = URL(string: "https://itunes.apple.com/us/app/Polocal/id1439122875?mt=8&action=write-review") else { return }
			UIApplication.shared.open(url)
			
			// doesn't do anything currently...
		} else if indexPath.section == 1 && indexPath.row == 1 {
			let email = "adam.eliezerov@gmail.com"
			if let url = URL(string: "mailto:\(email)") {
				if #available(iOS 10.0, *) {
					UIApplication.shared.open(url)
				} else {
					UIApplication.shared.openURL(url)
				}
			}
		} else if indexPath.section == 1 && indexPath.row == 2 {
			let alert = UIAlertController(title: "Privacy Policy", message: privacyPolicy, preferredStyle: UIAlertControllerStyle.alert)
			alert.addAction(UIAlertAction(title: "המשך", style: UIAlertActionStyle.default, handler: nil))
			self.present(alert, animated: true, completion: nil)
		} else if indexPath.section == 1 && indexPath.row == 3 {
			let alert = UIAlertController(title: "Terms Of Service", message: TOS, preferredStyle: UIAlertControllerStyle.alert)
			alert.addAction(UIAlertAction(title: "המשך", style: UIAlertActionStyle.default, handler: nil))
			self.present(alert, animated: true, completion: nil)
		}
		
	}

	
	
	let privacyPolicy = """
						\n
						Polocal built the Polocal app as a Free app. This SERVICE is provided by Polocal at no cost and is intended for use as is.

						This page is used to inform visitors regarding our policies with the collection, use, and disclosure of Personal Information if anyone decided to use our Service.

						If you choose to use our Service, then you agree to the collection and use of information in relation to this policy. The Personal Information that we collect is used for providing and improving the Service. We will not use or share your information with anyone except as described in this Privacy Policy.

						The terms used in this Privacy Policy have the same meanings as in our Terms and Conditions, which is accessible at Polocal unless otherwise defined in this Privacy Policy.

						Information Collection and Use

						For a better experience, while using our Service, we may require you to provide us with certain personally identifiable information, including but not limited to Polocal. The information that we request will be retained by us and used as described in this privacy policy.

						The app does use third party services that may collect information used to identify you.

						Link to privacy policy of third party service providers used by the app

						Log Data

						We want to inform you that whenever you use our Service, in a case of an error in the app we collect data and information (through third party products) on your phone called Log Data. This Log Data may include information such as your device Internet Protocol (“IP”) address, device name, operating system version, the configuration of the app when utilizing our Service, the time and date of your use of the Service, and other statistics.

						Cookies

						Cookies are files with a small amount of data that are commonly used as anonymous unique identifiers. These are sent to your browser from the websites that you visit and are stored on your device's internal memory.

						This Service does not use these “cookies” explicitly. However, the app may use third party code and libraries that use “cookies” to collect information and improve their services. You have the option to either accept or refuse these cookies and know when a cookie is being sent to your device. If you choose to refuse our cookies, you may not be able to use some portions of this Service.

						Service Providers

						We may employ third-party companies and individuals due to the following reasons:

						To facilitate our Service;
						To provide the Service on our behalf;
						To perform Service-related services; or
						To assist us in analyzing how our Service is used.
						We want to inform users of this Service that these third parties have access to your Personal Information. The reason is to perform the tasks assigned to them on our behalf. However, they are obligated not to disclose or use the information for any other purpose.

						Security

						We value your trust in providing us your Personal Information, thus we are striving to use commercially acceptable means of protecting it. But remember that no method of transmission over the internet, or method of electronic storage is 100% secure and reliable, and we cannot guarantee its absolute security.

						Links to Other Sites

						This Service may contain links to other sites. If you click on a third-party link, you will be directed to that site. Note that these external sites are not operated by us. Therefore, we strongly advise you to review the Privacy Policy of these websites. We have no control over and assume no responsibility for the content, privacy policies, or practices of any third-party sites or services.

						Children’s Privacy

						These Services do not address anyone under the age of 13. We do not knowingly collect personally identifiable information from children under 13. In the case we discover that a child under 13 has provided us with personal information, we immediately delete this from our servers. If you are a parent or guardian and you are aware that your child has provided us with personal information, please contact us so that we will be able to do necessary actions.

						Changes to This Privacy Policy

						We may update our Privacy Policy from time to time. Thus, you are advised to review this page periodically for any changes. We will notify you of any changes by posting the new Privacy Policy on this page. These changes are effective immediately after they are posted on this page.

						Contact Us

						If you have any questions or suggestions about our Privacy Policy, do not hesitate to contact us.

						"""
	
	let TOS = """
			\n
			Privacy Policy of Polocal
			In order to receive information about your Personal Data, the purposes and the parties the Data is shared with, contact the Owner.

			Owner and Data Controller
			Types of Data collected
			The owner does not provide a list of Personal Data types collected.

			Complete details on each type of Personal Data collected are provided in the dedicated sections of this privacy policy or by specific explanation texts displayed prior to the Data collection.
			Personal Data may be freely provided by the User, or, in case of Usage Data, collected automatically when using this Application.
			Unless specified otherwise, all Data requested by this Application is mandatory and failure to provide this Data may make it impossible for this Application to provide its services. In cases where this Application specifically states that some Data is not mandatory, Users are free not to communicate this Data without consequences to the availability or the functioning of the Service.
			Users who are uncertain about which Personal Data is mandatory are welcome to contact the Owner.
			Any use of Cookies – or of other tracking tools – by this Application or by the owners of third-party services used by this Application serves the purpose of providing the Service required by the User, in addition to any other purposes described in the present document and in the Cookie Policy, if available.

			Users are responsible for any third-party Personal Data obtained, published or shared through this Application and confirm that they have the third party's consent to provide the Data to the Owner.

			Mode and place of processing the Data
			Methods of processing
			The Owner takes appropriate security measures to prevent unauthorized access, disclosure, modification, or unauthorized destruction of the Data.
			The Data processing is carried out using computers and/or IT enabled tools, following organizational procedures and modes strictly related to the purposes indicated. In addition to the Owner, in some cases, the Data may be accessible to certain types of persons in charge, involved with the operation of this Application (administration, sales, marketing, legal, system administration) or external parties (such as third-party technical service providers, mail carriers, hosting providers, IT companies, communications agencies) appointed, if necessary, as Data Processors by the Owner. The updated list of these parties may be requested from the Owner at any time.

			Legal basis of processing
			The Owner may process Personal Data relating to Users if one of the following applies:

			Users have given their consent for one or more specific purposes. Note: Under some legislations the Owner may be allowed to process Personal Data until the User objects to such processing (“opt-out”), without having to rely on consent or any other of the following legal bases. This, however, does not apply, whenever the processing of Personal Data is subject to European data protection law;
			provision of Data is necessary for the performance of an agreement with the User and/or for any pre-contractual obligations thereof;
			processing is necessary for compliance with a legal obligation to which the Owner is subject;
			processing is related to a task that is carried out in the public interest or in the exercise of official authority vested in the Owner;
			processing is necessary for the purposes of the legitimate interests pursued by the Owner or by a third party.
			In any case, the Owner will gladly help to clarify the specific legal basis that applies to the processing, and in particular whether the provision of Personal Data is a statutory or contractual requirement, or a requirement necessary to enter into a contract.

			Place
			The Data is processed at the Owner's operating offices and in any other places where the parties involved in the processing are located.

			Depending on the User's location, data transfers may involve transferring the User's Data to a country other than their own. To find out more about the place of processing of such transferred Data, Users can check the section containing details about the processing of Personal Data.

			Users are also entitled to learn about the legal basis of Data transfers to a country outside the European Union or to any international organization governed by public international law or set up by two or more countries, such as the UN, and about the security measures taken by the Owner to safeguard their Data.

			If any such transfer takes place, Users can find out more by checking the relevant sections of this document or inquire with the Owner using the information provided in the contact section.

			Retention time
			Personal Data shall be processed and stored for as long as required by the purpose they have been collected for.

			Therefore:

			Personal Data collected for purposes related to the performance of a contract between the Owner and the User shall be retained until such contract has been fully performed.
			Personal Data collected for the purposes of the Owner’s legitimate interests shall be retained as long as needed to fulfill such purposes. Users may find specific information regarding the legitimate interests pursued by the Owner within the relevant sections of this document or by contacting the Owner.
			The Owner may be allowed to retain Personal Data for a longer period whenever the User has given consent to such processing, as long as such consent is not withdrawn. Furthermore, the Owner may be obliged to retain Personal Data for a longer period whenever required to do so for the performance of a legal obligation or upon order of an authority.

			Once the retention period expires, Personal Data shall be deleted. Therefore, the right to access, the right to erasure, the right to rectification and the right to data portability cannot be enforced after expiration of the retention period.

			The rights of Users
			Users may exercise certain rights regarding their Data processed by the Owner.

			In particular, Users have the right to do the following:

			Withdraw their consent at any time. Users have the right to withdraw consent where they have previously given their consent to the processing of their Personal Data.
			Object to processing of their Data. Users have the right to object to the processing of their Data if the processing is carried out on a legal basis other than consent. Further details are provided in the dedicated section below.
			Access their Data. Users have the right to learn if Data is being processed by the Owner, obtain disclosure regarding certain aspects of the processing and obtain a copy of the Data undergoing processing.
			Verify and seek rectification. Users have the right to verify the accuracy of their Data and ask for it to be updated or corrected.
			Restrict the processing of their Data. Users have the right, under certain circumstances, to restrict the processing of their Data. In this case, the Owner will not process their Data for any purpose other than storing it.
			Have their Personal Data deleted or otherwise removed. Users have the right, under certain circumstances, to obtain the erasure of their Data from the Owner.
			Receive their Data and have it transferred to another controller. Users have the right to receive their Data in a structured, commonly used and machine readable format and, if technically feasible, to have it transmitted to another controller without any hindrance. This provision is applicable provided that the Data is processed by automated means and that the processing is based on the User's consent, on a contract which the User is part of or on pre-contractual obligations thereof.
			Lodge a complaint. Users have the right to bring a claim before their competent data protection authority.
			Details about the right to object to processing
			Where Personal Data is processed for a public interest, in the exercise of an official authority vested in the Owner or for the purposes of the legitimate interests pursued by the Owner, Users may object to such processing by providing a ground related to their particular situation to justify the objection.

			Users must know that, however, should their Personal Data be processed for direct marketing purposes, they can object to that processing at any time without providing any justification. To learn, whether the Owner is processing Personal Data for direct marketing purposes, Users may refer to the relevant sections of this document.

			How to exercise these rights
			Any requests to exercise User rights can be directed to the Owner through the contact details provided in this document. These requests can be exercised free of charge and will be addressed by the Owner as early as possible and always within one month.

			Additional information about Data collection and processing
			Legal action
			The User's Personal Data may be used for legal purposes by the Owner in Court or in the stages leading to possible legal action arising from improper use of this Application or the related Services.
			The User declares to be aware that the Owner may be required to reveal personal data upon request of public authorities.

			Additional information about User's Personal Data
			In addition to the information contained in this privacy policy, this Application may provide the User with additional and contextual information concerning particular Services or the collection and processing of Personal Data upon request.

			System logs and maintenance
			For operation and maintenance purposes, this Application and any third-party services may collect files that record interaction with this Application (System logs) use other Personal Data (such as the IP Address) for this purpose.

			Information not contained in this policy
			More details concerning the collection or processing of Personal Data may be requested from the Owner at any time. Please see the contact information at the beginning of this document.

			How “Do Not Track” requests are handled
			This Application does not support “Do Not Track” requests.
			To determine whether any of the third-party services it uses honor the “Do Not Track” requests, please read their privacy policies.

			Changes to this privacy policy
			The Owner reserves the right to make changes to this privacy policy at any time by giving notice to its Users on this page and possibly within this Application and/or - as far as technically and legally feasible - sending a notice to Users via any contact information available to the Owner. It is strongly recommended to check this page often, referring to the date of the last modification listed at the bottom.

			Should the changes affect processing activities performed on the basis of the User’s consent, the Owner shall collect new consent from the User, where required.

			"""

}
