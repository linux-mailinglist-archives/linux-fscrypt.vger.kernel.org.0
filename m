Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A57AE1AC02
	for <lists+linux-fscrypt@lfdr.de>; Sun, 12 May 2019 14:22:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726540AbfELMWB (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Sun, 12 May 2019 08:22:01 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:40441 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726100AbfELMWB (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Sun, 12 May 2019 08:22:01 -0400
Received: by mail-pf1-f194.google.com with SMTP id u17so5651381pfn.7;
        Sun, 12 May 2019 05:22:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=ELUQWo6206cQbmtMbyBgzANoFNVPWh7eAjdZGcY87Qg=;
        b=keL1FdY8B91Ikpp/fWYMWdaaYMOeJpaIfEHC8ib0HY5fA4WXOwDtsx1Q3np13eCrZh
         0Pvmp0dEdmn0gYN0lvOOyWmeQDRCH+7/m1zz0Kg+zkISlWhqrBuRujZ/a28roeY1/kF5
         OV8G80OjXCQYC1eYpXWn6Ncw41SVjkMuCrBxttddYeYZnNSP6AVTKcgjyjgliiznp5/w
         9Ed1+tmZglpOELADIVEh1Bvb7tkFbbnwDwozuejdv9HRPU+zVuw3oLm1jx6pbCdb9qG6
         QUubdlUZsrhDH4jzRMjXaDAO26/NIXfIBQBDeRGFIFrsWL8fe7VM4htTmqCuHdIUk5Iz
         DSxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=ELUQWo6206cQbmtMbyBgzANoFNVPWh7eAjdZGcY87Qg=;
        b=OfxwxEzHdaeizVW55aysPSgmUB161iem/+vBW4VZJ1j7l8zEYY7JOrqJvScaLthh6B
         faOPb5tOCDWrMPsdkxVrScCDipxUlbb8Nyf5xFBFpr5l4GMTznhfv0fb8zfeFN+PIZej
         AZ5T/HdO8NYZ/BJcTLZkM/NOLQHedqyGIT6XwwYYXpCWlnTYoSK/TlvSX6vDMkk9hqVP
         sTPcDQ/z6egOYYrhvicFdoeRPNRPPdycgqMGiKh5lr15oqA+eSmT6dSGcgFSJaFuV6o7
         ffICP9Qs8I6G/ahbya4bTz7qPakUrYa9ZCminSJju5fCPPAdCaKa5dEN1KXDawSxa+BU
         Lc1A==
X-Gm-Message-State: APjAAAVmQsYnMMozstUeCQLWLnhHu8npjE5KkLA2BHOc6xZxGx/s8ziu
        3TUBydS5U7STFaK/dI0N8PQ=
X-Google-Smtp-Source: APXvYqzG8RD9SbCmfCUcvOEZmMxfQmjUgaue+go0FDpEeGeHFP7vZEBdb1zQVWlcDl3Z67K6gTme6w==
X-Received: by 2002:a63:4a66:: with SMTP id j38mr6694983pgl.199.1557663720054;
        Sun, 12 May 2019 05:22:00 -0700 (PDT)
Received: from localhost ([128.199.137.77])
        by smtp.gmail.com with ESMTPSA id f29sm6748183pfq.11.2019.05.12.05.21.58
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Sun, 12 May 2019 05:21:59 -0700 (PDT)
Date:   Sun, 12 May 2019 20:21:52 +0800
From:   Eryu Guan <guaneryu@gmail.com>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     fstests@vger.kernel.org, linux-fscrypt@vger.kernel.org,
        linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net
Subject: Re: [RFC PATCH 1/7] common/encrypt: introduce helpers for
 set_encpolicy and get_encpolicy
Message-ID: <20190512122152.GI15846@desktop>
References: <20190426204153.101861-1-ebiggers@kernel.org>
 <20190426204153.101861-2-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190426204153.101861-2-ebiggers@kernel.org>
User-Agent: Mutt/1.11.3 (2019-02-01)
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Fri, Apr 26, 2019 at 01:41:47PM -0700, Eric Biggers wrote:
> From: Eric Biggers <ebiggers@google.com>
> 
> For conciseness in tests, add helper functions that wrap the xfs_io
> commands 'set_encpolicy' and 'get_encpolicy'.  Then update all
> encryption tests to use them.
> 
> Signed-off-by: Eric Biggers <ebiggers@google.com>
> ---
>  common/encrypt        | 34 ++++++++++++++++++++++++++++++++--
>  tests/ext4/024        |  3 +--
>  tests/generic/395     | 28 +++++++++++++---------------
>  tests/generic/395.out |  2 +-
>  tests/generic/396     | 15 +++++++--------
>  tests/generic/397     |  3 +--
>  tests/generic/398     |  5 ++---
>  tests/generic/399     |  3 +--
>  tests/generic/419     |  3 +--
>  tests/generic/421     |  3 +--
>  tests/generic/429     |  3 +--
>  tests/generic/435     |  3 +--
>  tests/generic/440     |  5 ++---
>  13 files changed, 64 insertions(+), 46 deletions(-)
> 
> diff --git a/common/encrypt b/common/encrypt
> index 1b10aa71..54d873fa 100644
> --- a/common/encrypt
> +++ b/common/encrypt
> @@ -38,8 +38,7 @@ _require_scratch_encryption()
>  	# presence of /sys/fs/ext4/features/encryption, but this is broken on
>  	# some older kernels and is ext4-specific anyway.)
>  	mkdir $SCRATCH_MNT/tmpdir
> -	if $XFS_IO_PROG -c set_encpolicy $SCRATCH_MNT/tmpdir \
> -		2>&1 >>$seqres.full | \
> +	if _set_encpolicy $SCRATCH_MNT/tmpdir 2>&1 >>$seqres.full | \
>  		egrep -q 'Inappropriate ioctl for device|Operation not supported'
>  	then
>  		_notrun "kernel does not support $FSTYP encryption"
> @@ -175,3 +174,34 @@ _revoke_encryption_key()
>  	local keyid=$($KEYCTL_PROG search @s logon $FSTYP:$keydesc)
>  	$KEYCTL_PROG revoke $keyid >>$seqres.full
>  }
> +
> +# Set an encryption policy on the specified directory.
> +_set_encpolicy()
> +{
> +	local dir=$1
> +	shift
> +
> +	$XFS_IO_PROG -c "set_encpolicy $*" "$dir"
> +}
> +
> +_user_do_set_encpolicy()
> +{
> +	local dir=$1
> +	shift
> +
> +	_user_do "$XFS_IO_PROG -c \"set_encpolicy $*\" \"$dir\""
> +}
> +
> +_require_get_encpolicy()
> +{
> +	_require_xfs_io_command "get_encpolicy"
> +}

This doesn't seem necessary to me, just calling

_require_xfs_io_command "get_encpolicy"

explicitly is fine to me.

Thanks,
Eryu
