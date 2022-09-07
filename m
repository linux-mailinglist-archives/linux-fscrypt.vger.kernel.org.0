Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 615005AFFCE
	for <lists+linux-fscrypt@lfdr.de>; Wed,  7 Sep 2022 11:02:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229626AbiIGJCf (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 7 Sep 2022 05:02:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229583AbiIGJCe (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 7 Sep 2022 05:02:34 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E1DFA0274
        for <linux-fscrypt@vger.kernel.org>; Wed,  7 Sep 2022 02:02:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1662541351;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=5XCjOPBCKTGawIba4PtqFd9eVoBZ2iVl0X3kd07oSCM=;
        b=L7XNvhbNCqXv/7gAI/yznbbqd4d7iPUaUoR2pxpjWLQvBFpOwNFpMpfgfHLZos6DLyGUrU
        ef+dAudKt6s5tNoPci28K9aEAXkJwZoMnjkHyyddXL9bSt/hF1xKj1+PaxgvxtQA9E8aGz
        pqj7zxMcM0zu+Rgde36aRsfvVie9/vs=
Received: from mail-qv1-f72.google.com (mail-qv1-f72.google.com
 [209.85.219.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-663-bDV9yPMCMaS6ahfW06bFig-1; Wed, 07 Sep 2022 05:02:30 -0400
X-MC-Unique: bDV9yPMCMaS6ahfW06bFig-1
Received: by mail-qv1-f72.google.com with SMTP id u4-20020a0c8dc4000000b00498f6359b6dso9716373qvb.17
        for <linux-fscrypt@vger.kernel.org>; Wed, 07 Sep 2022 02:02:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=5XCjOPBCKTGawIba4PtqFd9eVoBZ2iVl0X3kd07oSCM=;
        b=tmzE5ae7pAClkU84N8VoSQVaAYOGrUB+WX5OiwjDMuLqdqEXri+lowU4nDCCrlR54z
         7PSEiG90SBJhEuG45fnXKElEfjJ9QMxFLmVY35DlAyq52mWzQM1QqkPVQsWxjKdxiKYi
         VjzPFwyNlby6nf+AWNR9JXXQdgyIHMYA/kj/GaF10sHHl5XLTV0yoEyDq86bIQc1EcGq
         P110eavA2cJ8E2Mt3ceh48bRADfb0E6dJfiDLY/k9uL6DBMsQyWvUyU1VW2ZjeRCtC+0
         JXqPhd5FVemIsGKpSAY1+pVN32iurg5gt8nBQc5qCo7OxdZaI9GS81xo2opt9HVjUwqX
         QGpg==
X-Gm-Message-State: ACgBeo3GUiu38nEAj4rSV9nToeN9qQGFaRPWGmo6hGn4kru091HH+u3B
        OUG7sp2sEc7pxgvtfzzdbIc1AD8wOGZS9pL33e5C+7Eo8FfF0Tr0fVzQqsde8zWagz6R+g1I49L
        AdftLNuXnq0eIv+fwDqFZn/58LQ==
X-Received: by 2002:ae9:f707:0:b0:6bb:e6e8:a1d9 with SMTP id s7-20020ae9f707000000b006bbe6e8a1d9mr1942905qkg.358.1662541348955;
        Wed, 07 Sep 2022 02:02:28 -0700 (PDT)
X-Google-Smtp-Source: AA6agR6a5WSUQPoKKDJDYQTLj8uVNwWgZUDv1Drg/hygRW1lKvriN+7Ab7fdHAyzx2i4spfaOMj5Wg==
X-Received: by 2002:ae9:f707:0:b0:6bb:e6e8:a1d9 with SMTP id s7-20020ae9f707000000b006bbe6e8a1d9mr1942882qkg.358.1662541348550;
        Wed, 07 Sep 2022 02:02:28 -0700 (PDT)
Received: from zlang-mailbox ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id n76-20020a37404f000000b006baed2827f2sm13057186qka.44.2022.09.07.02.02.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Sep 2022 02:02:28 -0700 (PDT)
Date:   Wed, 7 Sep 2022 17:02:23 +0800
From:   Zorro Lang <zlang@redhat.com>
To:     Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
Cc:     fstests@vger.kernel.org, linux-fscrypt@vger.kernel.org,
        linux-btrfs@vger.kernel.org, kernel-team@fb.com
Subject: Re: [PATCH 1/2] fstests: fscrypt: enable btrfs testing.
Message-ID: <20220907090223.wgxntmr447g3zblq@zlang-mailbox>
References: <cover.1662417905.git.sweettea-kernel@dorminy.me>
 <0152f016b3dd71b6fe152f71b05bb9517a2e748c.1662417905.git.sweettea-kernel@dorminy.me>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0152f016b3dd71b6fe152f71b05bb9517a2e748c.1662417905.git.sweettea-kernel@dorminy.me>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Mon, Sep 05, 2022 at 08:31:37PM -0400, Sweet Tea Dorminy wrote:
> btrfs' fscrypt integration has more stringent requirements than other
> filesystems using fscrypt: the default policy is not permitted.
> 
> To make many pass, this adds several common pieces:
> - _set_encpolicy tries to automatically use a direct-key Adiantum policy
>   for btrfs, if none is set.
> - for many tests using a default policy, a filter is applied to make
>   default policy for most FS's, or Adiantum for btrfs, work.
> - _scratch_mkfs_sized_encrypted can deal with btrfs
> 
> These pieces are used in tests to make most generic tests work with
> btrfs, and a new test is added resembling generic/395 to account for
> btrfs' directory policy.
> 
> Signed-off-by: Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
> ---
>  common/encrypt        | 72 +++++++++++++++++++++++++++++++++++-
>  common/verity         |  2 +-
>  tests/btrfs/298       | 85 +++++++++++++++++++++++++++++++++++++++++++
>  tests/btrfs/298.out   | 47 ++++++++++++++++++++++++
>  tests/generic/395     | 10 +++--
>  tests/generic/395.out | 18 ++++-----
>  tests/generic/435     | 10 ++++-
>  tests/generic/576     |  3 +-
>  tests/generic/576.out |  6 +--
>  tests/generic/580     |  5 ++-
>  tests/generic/580.out | 18 ++++-----
>  tests/generic/581     |  4 +-
>  tests/generic/581.out | 12 +++---
>  13 files changed, 252 insertions(+), 40 deletions(-)
>  create mode 100755 tests/btrfs/298
>  create mode 100644 tests/btrfs/298.out
> 
> diff --git a/common/encrypt b/common/encrypt
> index 8f3c46f6..c2e3e6f6 100644
> --- a/common/encrypt
> +++ b/common/encrypt
> @@ -102,7 +102,7 @@ _require_encryption_policy_support()
>  		_scratch_unmount
>  		_scratch_mkfs_stable_inodes_encrypted &>> $seqres.full
>  		_scratch_mount
> -	fi
> +	fi;

Is this change fix something wrong?

>  
>  	mkdir $dir
>  	if (( policy_version > 1 )); then
> @@ -146,7 +146,7 @@ _require_encryption_policy_support()
>  _scratch_mkfs_encrypted()
>  {
>  	case $FSTYP in
> -	ext4|f2fs)
> +	btrfs|ext4|f2fs)
>  		_scratch_mkfs -O encrypt
>  		;;
>  	ubifs)
> @@ -165,6 +165,9 @@ _scratch_mkfs_sized_encrypted()
>  	ext4|f2fs)
>  		MKFS_OPTIONS="$MKFS_OPTIONS -O encrypt" _scratch_mkfs_sized $*
>  		;;
> +	btrfs)
> +		_scratch_mkfs_sized $*

Why not change like above _scratch_mkfs_encrypted, why btrfs doesn't need
"-O encrypt" this time?

> +		;;
>  	*)
>  		_notrun "Filesystem $FSTYP not supported in _scratch_mkfs_sized_encrypted"
>  		;;
> @@ -356,6 +359,18 @@ _set_encpolicy()
>  {
>  	local dir=$1
>  	shift
> +	if [ "$FSTYP" = "btrfs" ]; then
> +		# Append DIRECT_KEY flag, and set mode to Adiantum, if not set.
> +		if ! [[ "$*" =~ -f ]]; then
> +		        set -- "$* -f ${FSCRYPT_POLICY_FLAG_DIRECT_KEY}"

I'm not familiar with this xfs_io "set_encpolicy", can this really *append* a
flag? If there's a "-f xxx" in "$*", won't your later one replace it? (same
question for below)

And could you explain why btrfs must need this specific handling in common
helper? Why not write it in cases which need that, due to you write as this
means it's always necessary for btrfs.

> +		fi
> +		if ! [[ "$*" =~ -c ]]; then
> +		        set -- "$* -c ${FSCRYPT_MODE_ADIANTUM}"
> +		fi
> +		if ! [[ "$*" =~ -n ]]; then
> +		        set -- "$* -n ${FSCRYPT_MODE_ADIANTUM}"
> +		fi
> +	fi
>  
>  	$XFS_IO_PROG -c "set_encpolicy $*" "$dir"
>  }
> @@ -364,6 +379,18 @@ _user_do_set_encpolicy()
>  {
>  	local dir=$1
>  	shift
> +       	if [ "$FSTYP" = "btrfs" ]; then

Bad indent

> +		# Append DIRECT_KEY flag, and set mode to Adiantum, if not set.
> +		if ! [[ "$*" =~ -f ]]; then
> +		        set -- "$* -f ${FSCRYPT_POLICY_FLAG_DIRECT_KEY}"
> +		fi
> +		if ! [[ "$*" =~ -c ]]; then
> +		        set -- "$* -c ${FSCRYPT_MODE_ADIANTUM}"
> +		fi
> +		if ! [[ "$*" =~ -n ]]; then
> +		        set -- "$* -n ${FSCRYPT_MODE_ADIANTUM}"
> +		fi
> +	fi
>  
>  	_user_do "$XFS_IO_PROG -c \"set_encpolicy $*\" \"$dir\""
>  }
> @@ -491,6 +518,18 @@ _get_encryption_nonce()
>  	local inode=$2
>  
>  	case $FSTYP in
> +	btrfs)
> +		# btrfs prints the fscrypt_context like:
> +		#
> +		# item 18 key (258 FSCRYPT_CTXT_ITEM 0) itemoff 15218 itemsize 40
> +		#	value: 0201042000000000000000000000000000000000000000007907c9718128b82caebfa42e881b0163
> +		#
> +		$BTRFS_UTIL_PROG inspect-internal dump-tree $device | \
> +			grep -A 1 "key ($inode FSCRYPT_CTXT_ITEM 0)" | \
> +			awk '/value: [[:xdigit:]]+$/ {
> +				print substr($0, length($0) - 31, 32);
> +			}'
> +		;;
>  	ext4)
>  		# Use debugfs to dump the special xattr named "c", which is the
>  		# file's fscrypt_context.  This produces a line like:
> @@ -539,6 +578,9 @@ _require_get_encryption_nonce_support()
>  {
>  	echo "Checking for _get_encryption_nonce() support for $FSTYP" >> $seqres.full
>  	case $FSTYP in
> +	btrfs)
> +		_require_command "$BTRFS_UTIL_PROG" btrfs
> +		;;
>  	ext4)
>  		_require_command "$DEBUGFS_PROG" debugfs
>  		;;
> @@ -888,6 +930,11 @@ _verify_ciphertext_for_encryption_policy()
>  	if (( policy_version > 1 )); then
>  		set_encpolicy_args+=" -v 2"
>  		crypt_util_args+=" --kdf=HKDF-SHA512"
> +		if [ "$FSTYP" = "btrfs" ]; then
> +			if (( policy_flags == 0 )); then
> +				_notrun "Btrfs does not accept default policies"
> +			fi	
> +		fi
>  		if (( policy_flags & FSCRYPT_POLICY_FLAG_DIRECT_KEY )); then
>  			crypt_util_args+=" --direct-key"
>  		elif (( policy_flags & FSCRYPT_POLICY_FLAG_IV_INO_LBLK_64 )); then
> @@ -1001,3 +1048,24 @@ _filter_nokey_filenames()
>  	# of characters that have ever been used in such names.
>  	sed "s|${dir}${dir:+/}[A-Za-z0-9+,_-]\+|${dir}${dir:+/}NOKEY_NAME|g"
>  }
> +
> +# Replace the default encryption mode for a filesystem with "DEFAULT".
> +_filter_default_encryption_mode()
> +{
> +	CONTENTS_PREFIX="Contents encryption mode:"
> +	DEFAULT_CONTENTS_MODE="1 (AES-256-XTS)"
> +	FILENAME_PREFIX="Filenames encryption mode:"
> +	DEFAULT_FILENAME_MODE="4 (AES-256-CTS)"
> +	DEFAULT_FLAGS="Flags: 0x02"
> +	
> +	if [ "$FSTYP" = "btrfs" ]; then
> +		DEFAULT_CONTENTS_MODE="9 (Adiantum)"
> +		DEFAULT_FILENAME_MODE="9 (Adiantum)"
> +		DEFAULT_FLAGS="Flags: 0x04"
> +	fi
> +
> +	sed "s/$CONTENTS_PREFIX $DEFAULT_CONTENTS_MODE/$CONTENTS_PREFIX DEFAULT/" | \
> +	sed "s/$FILENAME_PREFIX $DEFAULT_FILENAME_MODE/$FILENAME_PREFIX DEFAULT/" | \
> +	sed "s/$DEFAULT_FLAGS/Flags: DEFAULT/"
> +}
> +
> diff --git a/common/verity b/common/verity
> index cb7fa333..82a4ff90 100644
> --- a/common/verity
> +++ b/common/verity
> @@ -178,7 +178,7 @@ _scratch_mkfs_verity()
>  _scratch_mkfs_encrypted_verity()
>  {
>  	case $FSTYP in
> -	ext4)
> +	ext4|btrfs)
>  		_scratch_mkfs -O encrypt,verity
>  		;;
>  	f2fs)
> diff --git a/tests/btrfs/298 b/tests/btrfs/298
> new file mode 100755
> index 00000000..ff97fd87
> --- /dev/null
> +++ b/tests/btrfs/298
> @@ -0,0 +1,85 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (c) 2016 Google, Inc.  All Rights Reserved.

It's 2022 now

> +#
> +# FS QA Test No. 298
> +#
> +# Test setting and getting encryption policies. Like generic/395, but allows
> +# setting encryption policy on a nonempty directory.
> +#
> +. ./common/preamble
> +_begin_fstest auto quick encrypt
> +
> +# Import common functions.
> +. ./common/filter
> +. ./common/encrypt
> +
> +# real QA test starts here
> +_supported_fs generic

But you named this file as tests/btrfs/298. I'm wondering is there any reason
cause this case can't be a generic case?

I tried to compare with generic/395, looks like you write a separate case because
btrfs "Should be able to set an encryption policy on a nonempty directory", that
might cause a different .out output. If so, why not call *_link_out_file* in
generic/395, to use a different .out file for btrfs?

> +_require_scratch_encryption
> +_require_xfs_io_command "get_encpolicy"
> +_require_user
> +
> +_scratch_mkfs_encrypted &>> $seqres.full
> +_scratch_mount
> +
> +# Should be able to set an encryption policy on an empty directory
> +empty_dir=$SCRATCH_MNT/empty_dir
> +echo -e "\n*** Setting encryption policy on empty directory ***"
> +mkdir $empty_dir
> +_get_encpolicy $empty_dir |& _filter_scratch
> +_set_encpolicy $empty_dir 0000111122223333
> +_get_encpolicy $empty_dir | _filter_scratch | _filter_default_encryption_mode
> +
> +# Should be able to set the same policy again, but not a different one.
> +echo -e "\n*** Setting encryption policy again ***"
> +_set_encpolicy $empty_dir 0000111122223333
> +_get_encpolicy $empty_dir | _filter_scratch | _filter_default_encryption_mode
> +_set_encpolicy $empty_dir 4444555566667777 |& _filter_scratch
> +_get_encpolicy $empty_dir | _filter_scratch | _filter_default_encryption_mode
> +
> +# Should be able to set an encryption policy on a nonempty directory
> +nonempty_dir=$SCRATCH_MNT/nonempty_dir
> +echo -e "\n*** Setting encryption policy on nonempty directory ***"
> +mkdir $nonempty_dir
> +touch $nonempty_dir/file
> +_set_encpolicy $nonempty_dir | _filter_scratch
> +_get_encpolicy $nonempty_dir | _filter_scratch
> +
> +# Should *not* be able to set an encryption policy on a nondirectory file, even
> +# an empty one.  Regression test for 002ced4be642: "fscrypto: only allow setting
> +# encryption policy on directories".
> +nondirectory=$SCRATCH_MNT/nondirectory
> +echo -e "\n*** Setting encryption policy on nondirectory ***"
> +touch $nondirectory
> +_set_encpolicy $nondirectory |& _filter_scratch
> +_get_encpolicy $nondirectory |& _filter_scratch
> +
> +# Should *not* be able to set an encryption policy on another user's directory.
> +# Regression test for 163ae1c6ad62: "fscrypto: add authorization check for
> +# setting encryption policy".
> +unauthorized_dir=$SCRATCH_MNT/unauthorized_dir
> +echo -e "\n*** Setting encryption policy on another user's directory ***"
> +mkdir $unauthorized_dir
> +_user_do_set_encpolicy $unauthorized_dir |& _filter_scratch
> +_get_encpolicy $unauthorized_dir |& _filter_scratch
> +
> +# Should *not* be able to set an encryption policy on a directory on a
> +# filesystem mounted readonly.  Regression test for ba63f23d69a3: "fscrypto:
> +# require write access to mount to set encryption policy".  Test both a regular
> +# readonly filesystem and a readonly bind mount of a read-write filesystem.
> +echo -e "\n*** Setting encryption policy on readonly filesystem ***"
> +mkdir $SCRATCH_MNT/ro_dir $SCRATCH_MNT/ro_bind_mnt
> +_scratch_remount ro
> +_set_encpolicy $SCRATCH_MNT/ro_dir |& _filter_scratch
> +_get_encpolicy $SCRATCH_MNT/ro_dir |& _filter_scratch
> +_scratch_remount rw
> +mount --bind $SCRATCH_MNT $SCRATCH_MNT/ro_bind_mnt
> +mount -o remount,ro,bind $SCRATCH_MNT/ro_bind_mnt
> +_set_encpolicy $SCRATCH_MNT/ro_bind_mnt/ro_dir |& _filter_scratch
> +_get_encpolicy $SCRATCH_MNT/ro_bind_mnt/ro_dir |& _filter_scratch
> +umount $SCRATCH_MNT/ro_bind_mnt
> +
> +# success, all done
> +status=0
> +exit
> diff --git a/tests/btrfs/298.out b/tests/btrfs/298.out
> new file mode 100644
> index 00000000..5e311d3c
> --- /dev/null
> +++ b/tests/btrfs/298.out
> @@ -0,0 +1,47 @@
> +QA output created by 298
> +
> +*** Setting encryption policy on empty directory ***
> +SCRATCH_MNT/empty_dir: failed to get encryption policy: No data available
> +Encryption policy for SCRATCH_MNT/empty_dir:
> +	Policy version: 0
> +	Master key descriptor: 0000111122223333
> +	Contents encryption mode: DEFAULT
> +	Filenames encryption mode: DEFAULT
> +	Flags: DEFAULT
> +
> +*** Setting encryption policy again ***
> +Encryption policy for SCRATCH_MNT/empty_dir:
> +	Policy version: 0
> +	Master key descriptor: 0000111122223333
> +	Contents encryption mode: DEFAULT
> +	Filenames encryption mode: DEFAULT
> +	Flags: DEFAULT
> +SCRATCH_MNT/empty_dir: failed to set encryption policy: File exists
> +Encryption policy for SCRATCH_MNT/empty_dir:
> +	Policy version: 0
> +	Master key descriptor: 0000111122223333
> +	Contents encryption mode: DEFAULT
> +	Filenames encryption mode: DEFAULT
> +	Flags: DEFAULT
> +
> +*** Setting encryption policy on nonempty directory ***
> +Encryption policy for SCRATCH_MNT/nonempty_dir:
> +	Policy version: 0
> +	Master key descriptor: 0000000000000000
> +	Contents encryption mode: 9 (Adiantum)
> +	Filenames encryption mode: 9 (Adiantum)
> +	Flags: 0x04
> +
> +*** Setting encryption policy on nondirectory ***
> +SCRATCH_MNT/nondirectory: failed to set encryption policy: Not a directory
> +SCRATCH_MNT/nondirectory: failed to get encryption policy: No data available
> +
> +*** Setting encryption policy on another user's directory ***
> +Permission denied
> +SCRATCH_MNT/unauthorized_dir: failed to get encryption policy: No data available
> +
> +*** Setting encryption policy on readonly filesystem ***
> +SCRATCH_MNT/ro_dir: failed to set encryption policy: Read-only file system
> +SCRATCH_MNT/ro_dir: failed to get encryption policy: No data available
> +SCRATCH_MNT/ro_bind_mnt/ro_dir: failed to set encryption policy: Read-only file system
> +SCRATCH_MNT/ro_bind_mnt/ro_dir: failed to get encryption policy: No data available
> diff --git a/tests/generic/395 b/tests/generic/395
> index ab2ad612..d08544dc 100755
> --- a/tests/generic/395
> +++ b/tests/generic/395
> @@ -22,20 +22,24 @@ _require_user
>  _scratch_mkfs_encrypted &>> $seqres.full
>  _scratch_mount
>  
> +if [ "$FSTYP" = "btrfs" ]; then
> +	_notrun "Btrfs has a different non-empty directory policy"
> +fi
> +
>  # Should be able to set an encryption policy on an empty directory
>  empty_dir=$SCRATCH_MNT/empty_dir
>  echo -e "\n*** Setting encryption policy on empty directory ***"
>  mkdir $empty_dir
>  _get_encpolicy $empty_dir |& _filter_scratch
>  _set_encpolicy $empty_dir 0000111122223333
> -_get_encpolicy $empty_dir | _filter_scratch
> +_get_encpolicy $empty_dir | _filter_scratch | _filter_default_encryption_mode

Hmm... I think this single patch has too many different kind of changes, how
about split it to several patches, to help us to review it easily? Likes:
1) The 1st patch helps common helpers to support btrfs.
2) The 2nd patch brings in this _filter_default_encryption_mode helper.
3) The 3rd patch copy generic/395 to a new one, or use _link_out_file to help
it support btrfs.

Thanks,
Zorro

>  
>  # Should be able to set the same policy again, but not a different one.
>  echo -e "\n*** Setting encryption policy again ***"
>  _set_encpolicy $empty_dir 0000111122223333
> -_get_encpolicy $empty_dir | _filter_scratch
> +_get_encpolicy $empty_dir | _filter_scratch | _filter_default_encryption_mode
>  _set_encpolicy $empty_dir 4444555566667777 |& _filter_scratch
> -_get_encpolicy $empty_dir | _filter_scratch
> +_get_encpolicy $empty_dir | _filter_scratch | _filter_default_encryption_mode
>  
>  # Should *not* be able to set an encryption policy on a nonempty directory
>  nonempty_dir=$SCRATCH_MNT/nonempty_dir
> diff --git a/tests/generic/395.out b/tests/generic/395.out
> index 2c55d7a9..541cab50 100644
> --- a/tests/generic/395.out
> +++ b/tests/generic/395.out
> @@ -5,24 +5,24 @@ SCRATCH_MNT/empty_dir: failed to get encryption policy: No data available
>  Encryption policy for SCRATCH_MNT/empty_dir:
>  	Policy version: 0
>  	Master key descriptor: 0000111122223333
> -	Contents encryption mode: 1 (AES-256-XTS)
> -	Filenames encryption mode: 4 (AES-256-CTS)
> -	Flags: 0x02
> +	Contents encryption mode: DEFAULT
> +	Filenames encryption mode: DEFAULT
> +	Flags: DEFAULT
>  
>  *** Setting encryption policy again ***
>  Encryption policy for SCRATCH_MNT/empty_dir:
>  	Policy version: 0
>  	Master key descriptor: 0000111122223333
> -	Contents encryption mode: 1 (AES-256-XTS)
> -	Filenames encryption mode: 4 (AES-256-CTS)
> -	Flags: 0x02
> +	Contents encryption mode: DEFAULT
> +	Filenames encryption mode: DEFAULT
> +	Flags: DEFAULT
>  SCRATCH_MNT/empty_dir: failed to set encryption policy: File exists
>  Encryption policy for SCRATCH_MNT/empty_dir:
>  	Policy version: 0
>  	Master key descriptor: 0000111122223333
> -	Contents encryption mode: 1 (AES-256-XTS)
> -	Filenames encryption mode: 4 (AES-256-CTS)
> -	Flags: 0x02
> +	Contents encryption mode: DEFAULT
> +	Filenames encryption mode: DEFAULT
> +	Flags: DEFAULT
>  
>  *** Setting encryption policy on nonempty directory ***
>  SCRATCH_MNT/nonempty_dir: failed to set encryption policy: Directory not empty
> diff --git a/tests/generic/435 b/tests/generic/435
> index bb1cbb62..374e2a29 100755
> --- a/tests/generic/435
> +++ b/tests/generic/435
> @@ -27,6 +27,13 @@ _supported_fs generic
>  _require_scratch_encryption
>  _require_command "$KEYCTL_PROG" keyctl
>  
> +# -f 0x2: zero-pad to 16-byte boundary (i.e. encryption block boundary)
> +FLAGS_NEEDED=0x2
> +if [ "$FSTYP" = "btrfs" ]; then
> +	# btrfs must use a direct key policy
> +	FLAGS_NEEDED=0x6
> +fi
> +
>  # set up an encrypted directory
>  
>  _init_session_keyring
> @@ -34,8 +41,7 @@ _scratch_mkfs_encrypted &>> $seqres.full
>  _scratch_mount
>  mkdir $SCRATCH_MNT/edir
>  keydesc=$(_generate_session_encryption_key)
> -# -f 0x2: zero-pad to 16-byte boundary (i.e. encryption block boundary)
> -_set_encpolicy $SCRATCH_MNT/edir $keydesc -f 0x2
> +_set_encpolicy $SCRATCH_MNT/edir $keydesc -f $FLAGS_NEEDED
>  
>  # Create files with long names (> 32 bytes, long enough to trigger the use of
>  # "digested" names) in the encrypted directory.
> diff --git a/tests/generic/576 b/tests/generic/576
> index c8862de2..fbd72f8c 100755
> --- a/tests/generic/576
> +++ b/tests/generic/576
> @@ -51,7 +51,8 @@ cp $fsv_orig_file $fsv_file
>  _fsv_enable $fsv_file
>  echo
>  $XFS_IO_PROG -r -c "get_encpolicy" $fsv_file | _filter_scratch \
> -	| sed 's/Master key descriptor:.*/Master key descriptor: 0000000000000000/'
> +	| sed 's/Master key descriptor:.*/Master key descriptor: 0000000000000000/' \
> +	| _filter_default_encryption_mode
>  echo
>  
>  # Verify that the file contents are as expected.  This should be going through
> diff --git a/tests/generic/576.out b/tests/generic/576.out
> index cd8527b9..3d875b62 100644
> --- a/tests/generic/576.out
> +++ b/tests/generic/576.out
> @@ -3,9 +3,9 @@ QA output created by 576
>  Encryption policy for SCRATCH_MNT/edir/file.fsv:
>  	Policy version: 0
>  	Master key descriptor: 0000000000000000
> -	Contents encryption mode: 1 (AES-256-XTS)
> -	Filenames encryption mode: 4 (AES-256-CTS)
> -	Flags: 0x02
> +	Contents encryption mode: DEFAULT
> +	Filenames encryption mode: DEFAULT
> +	Flags: DEFAULT
>  
>  Files matched
>  Files matched
> diff --git a/tests/generic/580 b/tests/generic/580
> index 73f32ff9..8faa0dc2 100755
> --- a/tests/generic/580
> +++ b/tests/generic/580
> @@ -39,10 +39,11 @@ test_with_policy_version()
>  	echo "# Setting v$vers encryption policy"
>  	_set_encpolicy $dir $keyspec
>  	echo "# Getting v$vers encryption policy"
> -	_get_encpolicy $dir | _filter_scratch
> +	_get_encpolicy $dir | _filter_scratch | _filter_default_encryption_mode
>  	if (( vers == 1 )); then
>  		echo "# Getting v1 encryption policy using old ioctl"
> -		_get_encpolicy $dir -1 | _filter_scratch
> +		_get_encpolicy $dir -1 | _filter_scratch | \
> +			_filter_default_encryption_mode
>  	fi
>  	echo "# Trying to create file without key added yet"
>  	$XFS_IO_PROG -f $dir/file |& _filter_scratch
> diff --git a/tests/generic/580.out b/tests/generic/580.out
> index 989d4514..0c930827 100644
> --- a/tests/generic/580.out
> +++ b/tests/generic/580.out
> @@ -5,16 +5,16 @@ QA output created by 580
>  Encryption policy for SCRATCH_MNT/dir:
>  	Policy version: 0
>  	Master key descriptor: 0000111122223333
> -	Contents encryption mode: 1 (AES-256-XTS)
> -	Filenames encryption mode: 4 (AES-256-CTS)
> -	Flags: 0x02
> +	Contents encryption mode: DEFAULT
> +	Filenames encryption mode: DEFAULT
> +	Flags: DEFAULT
>  # Getting v1 encryption policy using old ioctl
>  Encryption policy for SCRATCH_MNT/dir:
>  	Policy version: 0
>  	Master key descriptor: 0000111122223333
> -	Contents encryption mode: 1 (AES-256-XTS)
> -	Filenames encryption mode: 4 (AES-256-CTS)
> -	Flags: 0x02
> +	Contents encryption mode: DEFAULT
> +	Filenames encryption mode: DEFAULT
> +	Flags: DEFAULT
>  # Trying to create file without key added yet
>  SCRATCH_MNT/dir/file: Required key not available
>  # Getting encryption key status
> @@ -52,9 +52,9 @@ cat: SCRATCH_MNT/dir/file: No such file or directory
>  Encryption policy for SCRATCH_MNT/dir:
>  	Policy version: 2
>  	Master key identifier: 69b2f6edeee720cce0577937eb8a6751
> -	Contents encryption mode: 1 (AES-256-XTS)
> -	Filenames encryption mode: 4 (AES-256-CTS)
> -	Flags: 0x02
> +	Contents encryption mode: DEFAULT
> +	Filenames encryption mode: DEFAULT
> +	Flags: DEFAULT
>  # Trying to create file without key added yet
>  SCRATCH_MNT/dir/file: Required key not available
>  # Getting encryption key status
> diff --git a/tests/generic/581 b/tests/generic/581
> index cabc7e1c..b2659b66 100755
> --- a/tests/generic/581
> +++ b/tests/generic/581
> @@ -52,7 +52,7 @@ echo "# Setting v1 policy as regular user (should succeed)"
>  _user_do_set_encpolicy $dir $keydesc
>  
>  echo "# Getting v1 policy as regular user (should succeed)"
> -_user_do_get_encpolicy $dir | _filter_scratch
> +_user_do_get_encpolicy $dir | _filter_scratch | _filter_default_encryption_mode
>  
>  echo "# Adding v1 policy key as regular user (should fail with EACCES)"
>  _user_do_add_enckey $SCRATCH_MNT "$raw_key" -d $keydesc
> @@ -71,7 +71,7 @@ echo "# Setting v2 policy as regular user with key added (should succeed)"
>  _user_do_set_encpolicy $dir $keyid
>  
>  echo "# Getting v2 policy as regular user (should succeed)"
> -_user_do_get_encpolicy $dir | _filter_scratch
> +_user_do_get_encpolicy $dir | _filter_scratch | _filter_default_encryption_mode
>  
>  echo "# Creating encrypted file as regular user (should succeed)"
>  _user_do "echo contents > $dir/file"
> diff --git a/tests/generic/581.out b/tests/generic/581.out
> index b3f7d889..544f7579 100644
> --- a/tests/generic/581.out
> +++ b/tests/generic/581.out
> @@ -5,9 +5,9 @@ QA output created by 581
>  Encryption policy for SCRATCH_MNT/dir:
>  	Policy version: 0
>  	Master key descriptor: 0000111122223333
> -	Contents encryption mode: 1 (AES-256-XTS)
> -	Filenames encryption mode: 4 (AES-256-CTS)
> -	Flags: 0x02
> +	Contents encryption mode: DEFAULT
> +	Filenames encryption mode: DEFAULT
> +	Flags: DEFAULT
>  # Adding v1 policy key as regular user (should fail with EACCES)
>  Permission denied
>  
> @@ -20,9 +20,9 @@ Added encryption key with identifier 69b2f6edeee720cce0577937eb8a6751
>  Encryption policy for SCRATCH_MNT/dir:
>  	Policy version: 2
>  	Master key identifier: 69b2f6edeee720cce0577937eb8a6751
> -	Contents encryption mode: 1 (AES-256-XTS)
> -	Filenames encryption mode: 4 (AES-256-CTS)
> -	Flags: 0x02
> +	Contents encryption mode: DEFAULT
> +	Filenames encryption mode: DEFAULT
> +	Flags: DEFAULT
>  # Creating encrypted file as regular user (should succeed)
>  # Removing v2 policy key as regular user (should succeed)
>  Removed encryption key with identifier 69b2f6edeee720cce0577937eb8a6751
> -- 
> 2.35.1
> 

