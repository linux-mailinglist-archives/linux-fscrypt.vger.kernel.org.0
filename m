Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 961C7BD501
	for <lists+linux-fscrypt@lfdr.de>; Wed, 25 Sep 2019 00:39:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393696AbfIXWjE (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Tue, 24 Sep 2019 18:39:04 -0400
Received: from sandeen.net ([63.231.237.45]:56310 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389629AbfIXWjE (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Tue, 24 Sep 2019 18:39:04 -0400
Received: from [10.0.0.4] (liberator [10.0.0.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id 29B3AD6E;
        Tue, 24 Sep 2019 17:38:57 -0500 (CDT)
Subject: Re: [PATCH v2 7/8] xfs_io/encrypt: add 'rm_enckey' command
To:     Eric Biggers <ebiggers@kernel.org>, linux-xfs@vger.kernel.org
Cc:     fstests@vger.kernel.org, linux-fscrypt@vger.kernel.org
References: <20190920001822.257411-1-ebiggers@kernel.org>
 <20190920001822.257411-8-ebiggers@kernel.org>
From:   Eric Sandeen <sandeen@sandeen.net>
Openpgp: preference=signencrypt
Autocrypt: addr=sandeen@sandeen.net; prefer-encrypt=mutual; keydata=
 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 pA==
Message-ID: <bdfb64e2-fb21-7e42-63ec-e9caddd13287@sandeen.net>
Date:   Tue, 24 Sep 2019 17:39:02 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20190920001822.257411-8-ebiggers@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On 9/19/19 7:18 PM, Eric Biggers wrote:
> From: Eric Biggers <ebiggers@google.com>
> 
> Add a 'rm_enckey' command to xfs_io, to provide a command-line interface
> to the FS_IOC_REMOVE_ENCRYPTION_KEY and
> FS_IOC_REMOVE_ENCRYPTION_KEY_ALL_USERS ioctls.
> 
> Signed-off-by: Eric Biggers <ebiggers@google.com>
> ---
>  io/encrypt.c      | 75 +++++++++++++++++++++++++++++++++++++++++++++++
>  man/man8/xfs_io.8 | 15 ++++++++++
>  2 files changed, 90 insertions(+)
> 
> diff --git a/io/encrypt.c b/io/encrypt.c
> index d38ac595..7531c4ad 100644
> --- a/io/encrypt.c
> +++ b/io/encrypt.c
> @@ -139,6 +139,7 @@ struct fscrypt_get_key_status_arg {
>  static cmdinfo_t get_encpolicy_cmd;
>  static cmdinfo_t set_encpolicy_cmd;
>  static cmdinfo_t add_enckey_cmd;
> +static cmdinfo_t rm_enckey_cmd;
>  
>  static void
>  get_encpolicy_help(void)
> @@ -200,6 +201,21 @@ add_enckey_help(void)
>  "\n"));
>  }
>  
> +static void
> +rm_enckey_help(void)
> +{
> +	printf(_(
> +"\n"
> +" remove an encryption key from the filesystem\n"
> +"\n"
> +" Examples:\n"
> +" 'rm_enckey 0000111122223333' - remove key for v1 policies w/ given descriptor\n"
> +" 'rm_enckey 00001111222233334444555566667777' - remove key for v2 policies w/ given identifier\n"
> +"\n"
> +" -a -- remove key for all users who have added it (privileged operation)\n"
> +"\n"));
> +}
> +
>  static const struct {
>  	__u8 mode;
>  	const char *name;
> @@ -693,6 +709,54 @@ out:
>  	return 0;
>  }
>  
> +static int
> +rm_enckey_f(int argc, char **argv)
> +{
> +	int c;
> +	struct fscrypt_remove_key_arg arg;
> +	int ioc = FS_IOC_REMOVE_ENCRYPTION_KEY;
> +
> +	memset(&arg, 0, sizeof(arg));
> +
> +	while ((c = getopt(argc, argv, "a")) != EOF) {
> +		switch (c) {
> +		case 'a':
> +			ioc = FS_IOC_REMOVE_ENCRYPTION_KEY_ALL_USERS;
> +			break;
> +		default:
> +			return command_usage(&rm_enckey_cmd);
> +		}
> +	}
> +	argc -= optind;
> +	argv += optind;
> +
> +	if (argc != 1)
> +		return command_usage(&rm_enckey_cmd);
> +
> +	if (str2keyspec(argv[0], -1, &arg.key_spec) < 0)
> +		return 0;
> +
> +	if (ioctl(file->fd, ioc, &arg) != 0) {
> +		fprintf(stderr, "Error removing encryption key: %s\n",
> +			strerror(errno));
> +		exitcode = 1;
> +		return 0;
> +	}
> +	if (arg.removal_status_flags &
> +	    FSCRYPT_KEY_REMOVAL_STATUS_FLAG_OTHER_USERS) {
> +		printf("Removed user's claim to encryption key with %s %s\n",
> +		       keyspectype(&arg.key_spec), keyspec2str(&arg.key_spec));
> +	} else if (arg.removal_status_flags &
> +		   FSCRYPT_KEY_REMOVAL_STATUS_FLAG_FILES_BUSY) {
> +		printf("Removed encryption key with %s %s, but files still busy\n",
> +		       keyspectype(&arg.key_spec), keyspec2str(&arg.key_spec));
> +	} else {
> +		printf("Removed encryption key with %s %s\n",
> +		       keyspectype(&arg.key_spec), keyspec2str(&arg.key_spec));
> +	}
> +	return 0;
> +}
> +
>  void
>  encrypt_init(void)
>  {
> @@ -726,7 +790,18 @@ encrypt_init(void)
>  	add_enckey_cmd.oneline = _("add an encryption key to the filesystem");
>  	add_enckey_cmd.help = add_enckey_help;
>  
> +	rm_enckey_cmd.name = "rm_enckey";
> +	rm_enckey_cmd.cfunc = rm_enckey_f;
> +	rm_enckey_cmd.args = _("keyspec");

can you add "-a" to the args for the shorthelp/args here please?

I don't know anything about this stuff.  :(  Is it to be used as:

rm_enckey -a <keyspec> ?

> +	rm_enckey_cmd.argmin = 0;
> +	rm_enckey_cmd.argmax = -1;

I wonder if min/max should be 1/2 but eh, I think you catch wrong counts
in the function itself, just without the explicit message the built-in
checkers would give.

> +	rm_enckey_cmd.flags = CMD_NOMAP_OK | CMD_FOREIGN_OK;
> +	rm_enckey_cmd.oneline =
> +		_("remove an encryption key from the filesystem");
> +	rm_enckey_cmd.help = rm_enckey_help;
> +
>  	add_command(&get_encpolicy_cmd);
>  	add_command(&set_encpolicy_cmd);
>  	add_command(&add_enckey_cmd);
> +	add_command(&rm_enckey_cmd);
>  }
> diff --git a/man/man8/xfs_io.8 b/man/man8/xfs_io.8
> index 7d6a23fe..a6894778 100644
> --- a/man/man8/xfs_io.8
> +++ b/man/man8/xfs_io.8
> @@ -764,6 +764,21 @@ Otherwise, the key is added as a v2 policy key, and on success the resulting
>  .RE
>  .PD
>  .TP
> +.BI "rm_enckey " keyspec

show [-a] here as well?

> +On filesystems that support encryption, remove an encryption key from the
> +filesystem containing the currently open file.
> +.I keyspec
> +is a hex string specifying the key to remove, as a 16-character "key descriptor"
> +or a 32-character "key identifier".
> +.RS 1.0i
> +.PD 0
> +.TP 0.4i
> +.BI \-a
> +Remove the key for all users who have added it, not just the current user.  This
> +is a privileged operation.
> +.RE
> +.PD
> +.TP
>  .BR lsattr " [ " \-R " | " \-D " | " \-a " | " \-v " ]"
>  List extended inode flags on the currently open file. If the
>  .B \-R
> 
