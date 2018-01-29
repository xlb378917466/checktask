﻿using UIKit;

using CoreGraphics;

using LexisNexis.Red.Common.HelpClass;

namespace LexisNexis.Red.iOS
{
	public partial class ContactUsController : UIViewController
	{
		public ContactUsController () : base ("ContactUsController", null)
		{
			Title = "Contact us";
		}


		public override void DidReceiveMemoryWarning ()
		{
			// Releases the view if it doesn't have a superview.
			base.DidReceiveMemoryWarning ();
			
			// Release any cached data, images, etc that aren't in use.
		}

		public override void ViewDidLoad ()
		{
			base.ViewDidLoad ();
			
			// Perform any additional setup after loading the view, typically from a nib.
			TelLabel.Text = GlobalAccess.Instance.CurrentUserInfo.Country.ContactUs.Phone;
			InternationalTelLabel.Text = GlobalAccess.Instance.CurrentUserInfo.Country.ContactUs.InternationalCallers;
			FaxLabel.Text = GlobalAccess.Instance.CurrentUserInfo.Country.ContactUs.Fax;
			EmailTextView.Text = GlobalAccess.Instance.CurrentUserInfo.Country.ContactUs.Email;
			PostToUsTextView.Text = GlobalAccess.Instance.CurrentUserInfo.Country.ContactUs.PostToUs.Content;
			SendByDXTextView.Text = GlobalAccess.Instance.CurrentUserInfo.Country.ContactUs.SendByDX;

		}

		public override void ViewWillAppear (bool animated)
		{
			base.ViewWillAppear (animated);

			AppDisplayUtil.Instance.SetCurrentPopoverViewSize (new CGSize (320, 600));

		}
	}
}

