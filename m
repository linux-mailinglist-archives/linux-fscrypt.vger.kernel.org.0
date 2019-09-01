Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 04421A4911
	for <lists+linux-fscrypt@lfdr.de>; Sun,  1 Sep 2019 14:08:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728722AbfIAMIO (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Sun, 1 Sep 2019 08:08:14 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:36109 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727033AbfIAMIO (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Sun, 1 Sep 2019 08:08:14 -0400
Received: by mail-pg1-f193.google.com with SMTP id l21so5843249pgm.3;
        Sun, 01 Sep 2019 05:08:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=nwAgX+KVKe0J7IM0xLhboQ4OUlkE3bOlglikS5q0FG4=;
        b=CADsE7TyqcgxU41szBrslGuhoT65huN2HUvT5tTRWr1b1I3aipjHokM5v+J12LeJI1
         xma3EO0qBVK3L7W7Q1L6EFQD65qD/F1tk5s8cy7g9WTQQcz0GjVGg1Ot9QWB9VsQwbPt
         SxT2CZJ8eMiOxB11z/UQRZku0aJaQsMdjgQY1Xmumw8zWf1BvDy9i98A48aXXNs1r8uY
         OttKk9AabV5tNFDXRCqAipCco6KiI4S/1kp/kUO1DjmgzuPUsACvjXr5G6DgSW5Rm1VF
         PRa6Qg4XTPtqc4vdEvjxF9zuOzlnGHN6i3uhmjrKqm4U5yylWmAzUebnZ4ZdbzFZpNvk
         wKbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=nwAgX+KVKe0J7IM0xLhboQ4OUlkE3bOlglikS5q0FG4=;
        b=Lt/z+7k2EIBY17X6+T2OjgNoGQjzgKBGi6yjGC1TDYYMV2KJ6LhK93AuuDX8j7WdKE
         2pe/mna2sQfCo4Xz5dAkYJu/v3ImuT9BimNv6J7Mf80SeeLlhh1n2e4eR5t+5Ocvw1I5
         HUl5tpmGN0EcB/+siNZVpHcCFZ0ns85UccK1qw6/ZzWxiEVdLgbvxb8zLIX9GA78xIel
         ziiTLvWuFhS+39RtAt1ZLccPz3AnhpX1zVJU3StxHB6uJEPqh+/CaL3a48pqYXWXE5Rx
         w2zMwUte7NoGdcr10hg3JrK24dl44l6pLaZ8FY8iT5jgMy+i5aKcjuhVcrpz9veG3Ggr
         SZnQ==
X-Gm-Message-State: APjAAAW60buo5LbV+BXUQRDahSXp3BDPmRbzB+ctMlh2f59HGsKPz/fs
        6X8GOcO61UTyFCabcePhO6Q=
X-Google-Smtp-Source: APXvYqxm0HhHVBOvpWyI2lj8ZwtCab9IG6pXHKGiqwfhRM6xteVkQTZdXug2jNGDUBquzsnnVdtOmA==
X-Received: by 2002:a17:90a:9f05:: with SMTP id n5mr2978727pjp.103.1567339693363;
        Sun, 01 Sep 2019 05:08:13 -0700 (PDT)
Received: from localhost ([178.128.102.47])
        by smtp.gmail.com with ESMTPSA id o35sm9607066pgm.29.2019.09.01.05.08.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 01 Sep 2019 05:08:11 -0700 (PDT)
Date:   Sun, 1 Sep 2019 20:08:06 +0800
From:   Eryu Guan <guaneryu@gmail.com>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     fstests@vger.kernel.org, linux-fscrypt@vger.kernel.org
Subject: Re: [RFC PATCH 3/9] common/encrypt: support checking for v2
 encryption policy support
Message-ID: <20190901120320.GE2622@desktop>
References: <20190812175809.34810-1-ebiggers@kernel.org>
 <20190812175809.34810-4-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190812175809.34810-4-ebiggers@kernel.org>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Mon, Aug 12, 2019 at 10:58:03AM -0700, Eric Biggers wrote:
> From: Eric Biggers <ebiggers@google.com>
> 
> Allow passing '-v 2' to _require_scratch_encryption() to check for v2
> encryption policy support on the scratch device, and for xfs_io support
> for setting and getting v2 encryption policies.
> 
> Signed-off-by: Eric Biggers <ebiggers@google.com>
> ---
>  common/encrypt | 41 +++++++++++++++++++++++++++++++----------
>  1 file changed, 31 insertions(+), 10 deletions(-)
> 
> diff --git a/common/encrypt b/common/encrypt
> index a086e80f..fa6e2672 100644
> --- a/common/encrypt
> +++ b/common/encrypt
> @@ -6,12 +6,13 @@
>  
>  #
>  # _require_scratch_encryption [-c CONTENTS_MODE] [-n FILENAMES_MODE]
> +#			      [-v POLICY_VERSION]
>  #
>  # Require encryption support on the scratch device.
>  #
> -# This checks for support for the default type of encryption policy (AES-256-XTS
> -# and AES-256-CTS).  Options can be specified to also require support for a
> -# different type of encryption policy.
> +# This checks for support for the default type of encryption policy (v1 with
> +# AES-256-XTS and AES-256-CTS).  Options can be specified to also require
> +# support for a different type of encryption policy.
>  #
>  _require_scratch_encryption()
>  {
> @@ -68,13 +69,15 @@ _require_encryption_policy_support()
>  	local mnt=$1
>  	local dir=$mnt/tmpdir
>  	local set_encpolicy_args=""
> +	local policy_version=1
>  	local c
>  
>  	OPTIND=2
> -	while getopts "c:n:" c; do
> +	while getopts "c:n:v:" c; do
>  		case $c in
> -		c|n)
> +		c|n|v)
>  			set_encpolicy_args+=" -$c $OPTARG"
> +			[ $c = v ] && policy_version=$OPTARG

Why not checking 'v' in a separate case?

>  			;;
>  		*)
>  			_fail "Unrecognized option '$c'"
> @@ -87,10 +90,26 @@ _require_encryption_policy_support()
>  		>> $seqres.full
>  
>  	mkdir $dir
> -	_require_command "$KEYCTL_PROG" keyctl
> -	_new_session_keyring
> -	local keydesc=$(_generate_session_encryption_key)
> -	if _set_encpolicy $dir $keydesc $set_encpolicy_args \
> +	if (( policy_version > 1 )); then
> +		_require_xfs_io_command "get_encpolicy" "-t"
> +		local output=$(_get_encpolicy $dir -t)
> +		if [ "$output" != "supported" ]; then
> +			if [ "$output" = "unsupported" ]; then
> +				_notrun "kernel does not support $FSTYP encryption v2 API"
> +			fi
> +			_fail "Unexpected output from 'get_encpolicy -t'"

Print $output in the _fail message as well?

Thanks,
Eryu

> +		fi
> +		# Both the kernel and xfs_io support v2 encryption policies, and
> +		# therefore also filesystem-level keys -- since that's the only
> +		# way to provide keys for v2 policies.
> +		local raw_key=$(_generate_raw_encryption_key)
> +		local keyspec=$(_add_enckey $mnt "$raw_key" | awk '{print $NF}')
> +	else
> +		_require_command "$KEYCTL_PROG" keyctl
> +		_new_session_keyring
> +		local keyspec=$(_generate_session_encryption_key)
> +	fi
> +	if _set_encpolicy $dir $keyspec $set_encpolicy_args \
>  		2>&1 >>$seqres.full | egrep -q 'Invalid argument'; then
>  		_notrun "kernel does not support encryption policy: '$set_encpolicy_args'"
>  	fi
> @@ -103,7 +122,9 @@ _require_encryption_policy_support()
>  	if ! echo foo > $dir/file; then
>  		_notrun "encryption policy '$set_encpolicy_args' is unusable; probably missing kernel crypto API support"
>  	fi
> -	$KEYCTL_PROG clear @s
> +	if (( policy_version <= 1 )); then
> +		$KEYCTL_PROG clear @s
> +	fi
>  	rm -r $dir
>  }
>  
> -- 
> 2.23.0.rc1.153.gdeed80330f-goog
> 
