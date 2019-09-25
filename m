Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4018DBE352
	for <lists+linux-fscrypt@lfdr.de>; Wed, 25 Sep 2019 19:23:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2502234AbfIYRX2 (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 25 Sep 2019 13:23:28 -0400
Received: from sandeen.net ([63.231.237.45]:43462 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2505155AbfIYRX2 (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 25 Sep 2019 13:23:28 -0400
Received: from Liberator-6.local (liberator [10.0.0.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id CC4457908;
        Wed, 25 Sep 2019 12:23:18 -0500 (CDT)
Subject: Re: [RFC PATCH 4/8] xfs_io/encrypt: extend 'get_encpolicy' to support
 v2 policies
To:     Eric Biggers <ebiggers@kernel.org>, linux-xfs@vger.kernel.org
Cc:     fstests@vger.kernel.org, linux-fscrypt@vger.kernel.org
References: <20190812175635.34186-1-ebiggers@kernel.org>
 <20190812175635.34186-5-ebiggers@kernel.org>
From:   Eric Sandeen <sandeen@sandeen.net>
Openpgp: preference=signencrypt
Autocrypt: addr=sandeen@sandeen.net; prefer-encrypt=mutual; keydata=
 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 pA==
Message-ID: <93a8536c-191d-340e-2d18-2ef87d0dcd5d@sandeen.net>
Date:   Wed, 25 Sep 2019 12:23:25 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20190812175635.34186-5-ebiggers@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On 8/12/19 12:56 PM, Eric Biggers wrote:
> From: Eric Biggers <ebiggers@google.com>
> 
> get_encpolicy uses the FS_IOC_GET_ENCRYPTION_POLICY ioctl to retrieve
> the file's encryption policy, then displays it.  But that only works for
> v1 encryption policies.  A new ioctl, FS_IOC_GET_ENCRYPTION_POLICY_EX,
> has been introduced which is more flexible and can retrieve both v1 and
> v2 encryption policies.

...

> +static void
> +test_for_v2_policy_support(void)
> +{
> +	struct fscrypt_get_policy_ex_arg arg;
> +
> +	arg.policy_size = sizeof(arg.policy);
> +
> +	if (ioctl(file->fd, FS_IOC_GET_ENCRYPTION_POLICY_EX, &arg) == 0 ||
> +	    errno == ENODATA /* file unencrypted */) {
> +		printf("supported\n");
> +		return;
> +	}
> +	if (errno == ENOTTY) {
> +		printf("unsupported\n");
> +		return;
> +	}
> +	fprintf(stderr,
> +		"%s: unexpected error checking for FS_IOC_GET_ENCRYPTION_POLICY_EX support: %s\n",

Darrick also mentioned to me off-list that the io/encrypt.c code is chock full of
strings that really need to be _("translatable")

-Eric

> +		file->name, strerror(errno));
> +	exitcode = 1;
> +}
> +
> +static void
> +show_v1_encryption_policy(const struct fscrypt_policy_v1 *policy)
> +{
> +	printf("Encryption policy for %s:\n", file->name);
> +	printf("\tPolicy version: %u\n", policy->version);
> +	printf("\tMaster key descriptor: %s\n",
> +	       keydesc2str(policy->master_key_descriptor));
> +	printf("\tContents encryption mode: %u (%s)\n",
> +	       policy->contents_encryption_mode,
> +	       mode2str(policy->contents_encryption_mode));
> +	printf("\tFilenames encryption mode: %u (%s)\n",
> +	       policy->filenames_encryption_mode,
> +	       mode2str(policy->filenames_encryption_mode));
> +	printf("\tFlags: 0x%02x\n", policy->flags);
> +}
> +
> +static void
> +show_v2_encryption_policy(const struct fscrypt_policy_v2 *policy)
> +{
> +	printf("Encryption policy for %s:\n", file->name);
> +	printf("\tPolicy version: %u\n", policy->version);
> +	printf("\tMaster key identifier: %s\n",
> +	       keyid2str(policy->master_key_identifier));
> +	printf("\tContents encryption mode: %u (%s)\n",
> +	       policy->contents_encryption_mode,
> +	       mode2str(policy->contents_encryption_mode));
> +	printf("\tFilenames encryption mode: %u (%s)\n",
> +	       policy->filenames_encryption_mode,
> +	       mode2str(policy->filenames_encryption_mode));
> +	printf("\tFlags: 0x%02x\n", policy->flags);
> +}
> +
>  static int
>  get_encpolicy_f(int argc, char **argv)
>  {
> -	struct fscrypt_policy policy;
> +	int c;
> +	struct fscrypt_get_policy_ex_arg arg;
> +	bool only_use_v1_ioctl = false;
> +	int res;
>  
> -	if (ioctl(file->fd, FS_IOC_GET_ENCRYPTION_POLICY, &policy) < 0) {
> +	while ((c = getopt(argc, argv, "1t")) != EOF) {
> +		switch (c) {
> +		case '1':
> +			only_use_v1_ioctl = true;
> +			break;
> +		case 't':
> +			test_for_v2_policy_support();
> +			return 0;
> +		default:
> +			return command_usage(&get_encpolicy_cmd);
> +		}
> +	}
> +	argc -= optind;
> +	argv += optind;
> +
> +	if (argc != 0)
> +		return command_usage(&get_encpolicy_cmd);
> +
> +	/* first try the new ioctl */
> +	if (only_use_v1_ioctl) {
> +		res = -1;
> +		errno = ENOTTY;
> +	} else {
> +		arg.policy_size = sizeof(arg.policy);
> +		res = ioctl(file->fd, FS_IOC_GET_ENCRYPTION_POLICY_EX, &arg);
> +	}
> +
> +	/* fall back to the old ioctl */
> +	if (res != 0 && errno == ENOTTY)
> +		res = ioctl(file->fd, FS_IOC_GET_ENCRYPTION_POLICY,
> +			    &arg.policy.v1);
> +
> +	if (res != 0) {
>  		fprintf(stderr, "%s: failed to get encryption policy: %s\n",
>  			file->name, strerror(errno));
>  		exitcode = 1;
>  		return 0;
>  	}
>  
> -	printf("Encryption policy for %s:\n", file->name);
> -	printf("\tPolicy version: %u\n", policy.version);
> -	printf("\tMaster key descriptor: %s\n",
> -	       keydesc2str(policy.master_key_descriptor));
> -	printf("\tContents encryption mode: %u (%s)\n",
> -	       policy.contents_encryption_mode,
> -	       mode2str(policy.contents_encryption_mode));
> -	printf("\tFilenames encryption mode: %u (%s)\n",
> -	       policy.filenames_encryption_mode,
> -	       mode2str(policy.filenames_encryption_mode));
> -	printf("\tFlags: 0x%02x\n", policy.flags);
> +	switch (arg.policy.version) {
> +	case FSCRYPT_POLICY_V1:
> +		show_v1_encryption_policy(&arg.policy.v1);
> +		break;
> +	case FSCRYPT_POLICY_V2:
> +		show_v2_encryption_policy(&arg.policy.v2);
> +		break;
> +	default:
> +		printf("Encryption policy for %s:\n", file->name);
> +		printf("\tPolicy version: %u (unknown)\n", arg.policy.version);
> +		break;
> +	}
>  	return 0;
>  }
>  
> @@ -351,11 +467,13 @@ encrypt_init(void)
>  {
>  	get_encpolicy_cmd.name = "get_encpolicy";
>  	get_encpolicy_cmd.cfunc = get_encpolicy_f;
> +	get_encpolicy_cmd.args = _("[-1] [-t]");
>  	get_encpolicy_cmd.argmin = 0;
> -	get_encpolicy_cmd.argmax = 0;
> +	get_encpolicy_cmd.argmax = -1;
>  	get_encpolicy_cmd.flags = CMD_NOMAP_OK | CMD_FOREIGN_OK;
>  	get_encpolicy_cmd.oneline =
>  		_("display the encryption policy of the current file");
> +	get_encpolicy_cmd.help = get_encpolicy_help;
>  
>  	set_encpolicy_cmd.name = "set_encpolicy";
>  	set_encpolicy_cmd.cfunc = set_encpolicy_f;
> diff --git a/man/man8/xfs_io.8 b/man/man8/xfs_io.8
> index 6e064bdd..3dd34a0c 100644
> --- a/man/man8/xfs_io.8
> +++ b/man/man8/xfs_io.8
> @@ -724,10 +724,21 @@ version of policy structure (numeric)
>  .RE
>  .PD
>  .TP
> -.BR get_encpolicy
> +.BI "get_encpolicy [ \-1 ] [ \-t ]"
>  On filesystems that support encryption, display the encryption policy of the
>  current file.
> -
> +.RS 1.0i
> +.PD 0
> +.TP 0.4i
> +.BI \-1
> +Use only the old ioctl to get the encryption policy.  This only works if the
> +file has a v1 encryption policy.
> +.TP
> +.BI \-t
> +Test whether v2 encryption policies are supported.  Prints "supported",
> +"unsupported", or an error message.
> +.RE
> +.PD
>  .TP
>  .BR lsattr " [ " \-R " | " \-D " | " \-a " | " \-v " ]"
>  List extended inode flags on the currently open file. If the
> 
