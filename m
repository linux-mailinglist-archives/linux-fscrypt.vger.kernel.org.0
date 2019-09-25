Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 16AD1BE8CF
	for <lists+linux-fscrypt@lfdr.de>; Thu, 26 Sep 2019 01:11:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726708AbfIYXLD (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 25 Sep 2019 19:11:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:56624 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726203AbfIYXLD (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 25 Sep 2019 19:11:03 -0400
Received: from gmail.com (unknown [104.132.1.77])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7D9E620640;
        Wed, 25 Sep 2019 23:11:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569453061;
        bh=jMkmEqZg+OQEStsIVSEy9WP59v5NEoDyQ7+CMSZVABc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=diEfSkw444fhPSRnwBu+vZw6OEEBg9eEEfmShJrYw2/PfiisRde08OvMNLQl+7GF5
         p7LxhoumCT1usZtYiMtXp1NyYdnOU08ocuLcCO3fyh7y/TXXN+cD3tiS2VDJyWe67d
         2+6AwwkbR2YJz1Tj/6+m7M9uHF3Sxl5HcHGPYCrM=
Date:   Wed, 25 Sep 2019 16:11:00 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Eric Sandeen <sandeen@sandeen.net>
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org,
        linux-fscrypt@vger.kernel.org
Subject: Re: [PATCH v2 7/8] xfs_io/encrypt: add 'rm_enckey' command
Message-ID: <20190925231058.GA3163@gmail.com>
Mail-Followup-To: Eric Sandeen <sandeen@sandeen.net>,
        linux-xfs@vger.kernel.org, fstests@vger.kernel.org,
        linux-fscrypt@vger.kernel.org
References: <20190920001822.257411-1-ebiggers@kernel.org>
 <20190920001822.257411-8-ebiggers@kernel.org>
 <bdfb64e2-fb21-7e42-63ec-e9caddd13287@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bdfb64e2-fb21-7e42-63ec-e9caddd13287@sandeen.net>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Tue, Sep 24, 2019 at 05:39:02PM -0500, Eric Sandeen wrote:
> On 9/19/19 7:18 PM, Eric Biggers wrote:
> > From: Eric Biggers <ebiggers@google.com>
> > 
> > Add a 'rm_enckey' command to xfs_io, to provide a command-line interface
> > to the FS_IOC_REMOVE_ENCRYPTION_KEY and
> > FS_IOC_REMOVE_ENCRYPTION_KEY_ALL_USERS ioctls.
> > 
> > Signed-off-by: Eric Biggers <ebiggers@google.com>
> > ---
> >  io/encrypt.c      | 75 +++++++++++++++++++++++++++++++++++++++++++++++
> >  man/man8/xfs_io.8 | 15 ++++++++++
> >  2 files changed, 90 insertions(+)
> > 
> > diff --git a/io/encrypt.c b/io/encrypt.c
> > index d38ac595..7531c4ad 100644
> > --- a/io/encrypt.c
> > +++ b/io/encrypt.c
> > @@ -139,6 +139,7 @@ struct fscrypt_get_key_status_arg {
> >  static cmdinfo_t get_encpolicy_cmd;
> >  static cmdinfo_t set_encpolicy_cmd;
> >  static cmdinfo_t add_enckey_cmd;
> > +static cmdinfo_t rm_enckey_cmd;
> >  
> >  static void
> >  get_encpolicy_help(void)
> > @@ -200,6 +201,21 @@ add_enckey_help(void)
> >  "\n"));
> >  }
> >  
> > +static void
> > +rm_enckey_help(void)
> > +{
> > +	printf(_(
> > +"\n"
> > +" remove an encryption key from the filesystem\n"
> > +"\n"
> > +" Examples:\n"
> > +" 'rm_enckey 0000111122223333' - remove key for v1 policies w/ given descriptor\n"
> > +" 'rm_enckey 00001111222233334444555566667777' - remove key for v2 policies w/ given identifier\n"
> > +"\n"
> > +" -a -- remove key for all users who have added it (privileged operation)\n"
> > +"\n"));
> > +}
> > +
> >  static const struct {
> >  	__u8 mode;
> >  	const char *name;
> > @@ -693,6 +709,54 @@ out:
> >  	return 0;
> >  }
> >  
> > +static int
> > +rm_enckey_f(int argc, char **argv)
> > +{
> > +	int c;
> > +	struct fscrypt_remove_key_arg arg;
> > +	int ioc = FS_IOC_REMOVE_ENCRYPTION_KEY;
> > +
> > +	memset(&arg, 0, sizeof(arg));
> > +
> > +	while ((c = getopt(argc, argv, "a")) != EOF) {
> > +		switch (c) {
> > +		case 'a':
> > +			ioc = FS_IOC_REMOVE_ENCRYPTION_KEY_ALL_USERS;
> > +			break;
> > +		default:
> > +			return command_usage(&rm_enckey_cmd);
> > +		}
> > +	}
> > +	argc -= optind;
> > +	argv += optind;
> > +
> > +	if (argc != 1)
> > +		return command_usage(&rm_enckey_cmd);
> > +
> > +	if (str2keyspec(argv[0], -1, &arg.key_spec) < 0)
> > +		return 0;
> > +
> > +	if (ioctl(file->fd, ioc, &arg) != 0) {
> > +		fprintf(stderr, "Error removing encryption key: %s\n",
> > +			strerror(errno));
> > +		exitcode = 1;
> > +		return 0;
> > +	}
> > +	if (arg.removal_status_flags &
> > +	    FSCRYPT_KEY_REMOVAL_STATUS_FLAG_OTHER_USERS) {
> > +		printf("Removed user's claim to encryption key with %s %s\n",
> > +		       keyspectype(&arg.key_spec), keyspec2str(&arg.key_spec));
> > +	} else if (arg.removal_status_flags &
> > +		   FSCRYPT_KEY_REMOVAL_STATUS_FLAG_FILES_BUSY) {
> > +		printf("Removed encryption key with %s %s, but files still busy\n",
> > +		       keyspectype(&arg.key_spec), keyspec2str(&arg.key_spec));
> > +	} else {
> > +		printf("Removed encryption key with %s %s\n",
> > +		       keyspectype(&arg.key_spec), keyspec2str(&arg.key_spec));
> > +	}
> > +	return 0;
> > +}
> > +
> >  void
> >  encrypt_init(void)
> >  {
> > @@ -726,7 +790,18 @@ encrypt_init(void)
> >  	add_enckey_cmd.oneline = _("add an encryption key to the filesystem");
> >  	add_enckey_cmd.help = add_enckey_help;
> >  
> > +	rm_enckey_cmd.name = "rm_enckey";
> > +	rm_enckey_cmd.cfunc = rm_enckey_f;
> > +	rm_enckey_cmd.args = _("keyspec");
> 
> can you add "-a" to the args for the shorthelp/args here please?

Will do.

> 
> I don't know anything about this stuff.  :(  Is it to be used as:
> 
> rm_enckey -a <keyspec> ?

Yes, -a is just an optional argument.  Nothing special.

> 
> > +	rm_enckey_cmd.argmin = 0;
> > +	rm_enckey_cmd.argmax = -1;
> 
> I wonder if min/max should be 1/2 but eh, I think you catch wrong counts
> in the function itself, just without the explicit message the built-in
> checkers would give.

Well since there's only one option, we *could* pretend that it's an optional
positional argument, and do argmin=1, argmax=2, and

	if (argc == 2) {
		if (strcmp(argv[1], "-a") != 0)
			return command_usage(&rm_enckey_cmd);
		ioc = FS_IOC_REMOVE_ENCRYPTION_KEY_ALL_USERS;
		argv++;
	}

But all that would need to be changed if/when a second option is added.
IMO it's better to handle it in the standard way.

> 
> > +	rm_enckey_cmd.flags = CMD_NOMAP_OK | CMD_FOREIGN_OK;
> > +	rm_enckey_cmd.oneline =
> > +		_("remove an encryption key from the filesystem");
> > +	rm_enckey_cmd.help = rm_enckey_help;
> > +
> >  	add_command(&get_encpolicy_cmd);
> >  	add_command(&set_encpolicy_cmd);
> >  	add_command(&add_enckey_cmd);
> > +	add_command(&rm_enckey_cmd);
> >  }
> > diff --git a/man/man8/xfs_io.8 b/man/man8/xfs_io.8
> > index 7d6a23fe..a6894778 100644
> > --- a/man/man8/xfs_io.8
> > +++ b/man/man8/xfs_io.8
> > @@ -764,6 +764,21 @@ Otherwise, the key is added as a v2 policy key, and on success the resulting
> >  .RE
> >  .PD
> >  .TP
> > +.BI "rm_enckey " keyspec
> 
> show [-a] here as well?
> 

Will do.

- Eric
