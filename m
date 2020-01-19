Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AC1AA141C49
	for <lists+linux-fscrypt@lfdr.de>; Sun, 19 Jan 2020 06:45:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726060AbgASFpW (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Sun, 19 Jan 2020 00:45:22 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:38558 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725809AbgASFpV (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Sun, 19 Jan 2020 00:45:21 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579412719;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=4/hxy7UkuuwtwN2nfD5nTFJQzlJTggrkcT89ob1CLkA=;
        b=Qidx0AolcshIoeDxEDWavvSgY1JVi9u/5raYcy6nO/rLEA4wn4cS3wZqTRWW9YqyBGwwFO
        ZUruqkvI7GoDEixOZlit62YHhnZyGSFa5c2hpDJk4QCIhtSVYRsC+Pqoeji+FTMsqqsmN8
        Q29lkupzqc/G0mGYhqjre1C35uINPcw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-67-LLyl9R7iOGS_L27IpVTCcg-1; Sun, 19 Jan 2020 00:45:18 -0500
X-MC-Unique: LLyl9R7iOGS_L27IpVTCcg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0583F800D48;
        Sun, 19 Jan 2020 05:45:17 +0000 (UTC)
Received: from localhost (dhcp-12-196.nay.redhat.com [10.66.12.196])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 761E789E87;
        Sun, 19 Jan 2020 05:45:16 +0000 (UTC)
Date:   Sun, 19 Jan 2020 13:45:15 +0800
From:   Murphy Zhou <xzhou@redhat.com>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     fstests@vger.kernel.org, linux-fscrypt@vger.kernel.org
Subject: Re: [PATCH v3 6/9] generic: add test for non-root use of fscrypt API
 additions
Message-ID: <20200119054515.3mxrpky7fiegnj5s@xzhoux.usersys.redhat.com>
References: <20191015181643.6519-1-ebiggers@kernel.org>
 <20191015181643.6519-7-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191015181643.6519-7-ebiggers@kernel.org>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

Hi Eric,

On Tue, Oct 15, 2019 at 11:16:40AM -0700, Eric Biggers wrote:
> From: Eric Biggers <ebiggers@google.com>
> 
> Test non-root use of the fscrypt filesystem-level encryption keyring and
> v2 encryption policies.

This testcase now fails on latest Linus tree with latest e2fsprogs
on ext4:

FSTYP         -- ext4
PLATFORM      -- Linux/x86_64 dell-pesc430-01 5.4.0+ #1 SMP Mon Nov 25 16:40:55 EST 2019
MKFS_OPTIONS  -- /dev/sda3
MOUNT_OPTIONS -- -o acl,user_xattr -o context=system_u:object_r:nfs_t:s0 /dev/sda3 /mnt/xfstests/mnt2
generic/581	- output mismatch (see /var/lib/xfstests/results//generic/581.out.bad)
    --- tests/generic/581.out	2019-11-25 20:30:04.536051638 -0500
    +++ /var/lib/xfstests/results//generic/581.out.bad	2019-11-26 01:04:17.318332220 -0500
    @@ -33,7 +33,7 @@
     Added encryption key
     Added encryption key
     Added encryption key
    -Error adding encryption key: Disk quota exceeded
    +Added encryption key
     
     # Adding key as root
...

A rough looking back shows that this probably started since your fscrypt
update for 5.5, added support for IV_INO_LBLK_64 encryption policies.

I guess you are aware of this :-)

Thanks,
Murphy
> 
> Signed-off-by: Eric Biggers <ebiggers@google.com>
> ---
>  tests/generic/801     | 144 ++++++++++++++++++++++++++++++++++++++++++
>  tests/generic/801.out |  62 ++++++++++++++++++
>  tests/generic/group   |   1 +
>  3 files changed, 207 insertions(+)
>  create mode 100755 tests/generic/801
>  create mode 100644 tests/generic/801.out
> 
> diff --git a/tests/generic/801 b/tests/generic/801
> new file mode 100755
> index 00000000..c759ec94
> --- /dev/null
> +++ b/tests/generic/801
> @@ -0,0 +1,144 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright 2019 Google LLC
> +#
> +# FS QA Test generic/801
> +#
> +# Test non-root use of the fscrypt filesystem-level encryption keyring
> +# and v2 encryption policies.
> +#
> +
> +seq=`basename $0`
> +seqres=$RESULT_DIR/$seq
> +echo "QA output created by $seq"
> +echo
> +
> +here=`pwd`
> +tmp=/tmp/$$
> +status=1	# failure is the default!
> +trap "_cleanup; exit \$status" 0 1 2 3 15
> +orig_maxkeys=
> +
> +_cleanup()
> +{
> +	cd /
> +	rm -f $tmp.*
> +	if [ -n "$orig_maxkeys" ]; then
> +		echo "$orig_maxkeys" > /proc/sys/kernel/keys/maxkeys
> +	fi
> +}
> +
> +# get standard environment, filters and checks
> +. ./common/rc
> +. ./common/filter
> +. ./common/encrypt
> +
> +# remove previous $seqres.full before test
> +rm -f $seqres.full
> +
> +# real QA test starts here
> +_supported_fs generic
> +_supported_os Linux
> +_require_user
> +_require_scratch_encryption -v 2
> +
> +_scratch_mkfs_encrypted &>> $seqres.full
> +_scratch_mount
> +
> +# Set the fsgqa user's key quota to their current number of keys plus 5.
> +orig_keys=$(_user_do "awk '/^[[:space:]]*$(id -u fsgqa):/{print \$4}' /proc/key-users | cut -d/ -f1")
> +: ${orig_keys:=0}
> +echo "orig_keys=$orig_keys" >> $seqres.full
> +orig_maxkeys=$(</proc/sys/kernel/keys/maxkeys)
> +keys_to_add=5
> +echo $((orig_keys + keys_to_add)) > /proc/sys/kernel/keys/maxkeys
> +
> +dir=$SCRATCH_MNT/dir
> +
> +raw_key=""
> +for i in `seq 64`; do
> +	raw_key+="\\x$(printf "%02x" $i)"
> +done
> +keydesc="0000111122223333"
> +keyid="69b2f6edeee720cce0577937eb8a6751"
> +chmod 777 $SCRATCH_MNT
> +
> +_user_do "mkdir $dir"
> +
> +echo "# Setting v1 policy as regular user (should succeed)"
> +_user_do_set_encpolicy $dir $keydesc
> +
> +echo "# Getting v1 policy as regular user (should succeed)"
> +_user_do_get_encpolicy $dir | _filter_scratch
> +
> +echo "# Adding v1 policy key as regular user (should fail with EACCES)"
> +_user_do_add_enckey $SCRATCH_MNT "$raw_key" -d $keydesc
> +
> +rm -rf $dir
> +echo
> +_user_do "mkdir $dir"
> +
> +echo "# Setting v2 policy as regular user without key already added (should fail with ENOKEY)"
> +_user_do_set_encpolicy $dir $keyid |& _filter_scratch
> +
> +echo "# Adding v2 policy key as regular user (should succeed)"
> +_user_do_add_enckey $SCRATCH_MNT "$raw_key"
> +
> +echo "# Setting v2 policy as regular user with key added (should succeed)"
> +_user_do_set_encpolicy $dir $keyid
> +
> +echo "# Getting v2 policy as regular user (should succeed)"
> +_user_do_get_encpolicy $dir | _filter_scratch
> +
> +echo "# Creating encrypted file as regular user (should succeed)"
> +_user_do "echo contents > $dir/file"
> +
> +echo "# Removing v2 policy key as regular user (should succeed)"
> +_user_do_rm_enckey $SCRATCH_MNT $keyid
> +
> +_scratch_cycle_mount	# Clear all keys
> +
> +echo
> +echo "# Testing user key quota"
> +for i in `seq $((keys_to_add + 1))`; do
> +	rand_raw_key=$(_generate_raw_encryption_key)
> +	_user_do_add_enckey $SCRATCH_MNT "$rand_raw_key" \
> +	    | sed 's/ with identifier .*$//'
> +done
> +
> +rm -rf $dir
> +echo
> +_user_do "mkdir $dir"
> +_scratch_cycle_mount	# Clear all keys
> +
> +# Test multiple users adding the same key.
> +echo "# Adding key as root"
> +_add_enckey $SCRATCH_MNT "$raw_key"
> +echo "# Getting key status as regular user"
> +_user_do_enckey_status $SCRATCH_MNT $keyid
> +echo "# Removing key only added by another user (should fail with ENOKEY)"
> +_user_do_rm_enckey $SCRATCH_MNT $keyid
> +echo "# Setting v2 encryption policy with key only added by another user (should fail with ENOKEY)"
> +_user_do_set_encpolicy $dir $keyid |& _filter_scratch
> +echo "# Adding second user of key"
> +_user_do_add_enckey $SCRATCH_MNT "$raw_key"
> +echo "# Getting key status as regular user"
> +_user_do_enckey_status $SCRATCH_MNT $keyid
> +echo "# Setting v2 encryption policy as regular user"
> +_user_do_set_encpolicy $dir $keyid
> +echo "# Removing this user's claim to the key"
> +_user_do_rm_enckey $SCRATCH_MNT $keyid
> +echo "# Getting key status as regular user"
> +_user_do_enckey_status $SCRATCH_MNT $keyid
> +echo "# Adding back second user of key"
> +_user_do_add_enckey $SCRATCH_MNT "$raw_key"
> +echo "# Remove key for \"all users\", as regular user (should fail with EACCES)"
> +_user_do_rm_enckey $SCRATCH_MNT $keyid -a |& _filter_scratch
> +_enckey_status $SCRATCH_MNT $keyid
> +echo "# Remove key for \"all users\", as root"
> +_rm_enckey $SCRATCH_MNT $keyid -a
> +_enckey_status $SCRATCH_MNT $keyid
> +
> +# success, all done
> +status=0
> +exit
> diff --git a/tests/generic/801.out b/tests/generic/801.out
> new file mode 100644
> index 00000000..b5b6cec8
> --- /dev/null
> +++ b/tests/generic/801.out
> @@ -0,0 +1,62 @@
> +QA output created by 801
> +
> +# Setting v1 policy as regular user (should succeed)
> +# Getting v1 policy as regular user (should succeed)
> +Encryption policy for SCRATCH_MNT/dir:
> +	Policy version: 0
> +	Master key descriptor: 0000111122223333
> +	Contents encryption mode: 1 (AES-256-XTS)
> +	Filenames encryption mode: 4 (AES-256-CTS)
> +	Flags: 0x02
> +# Adding v1 policy key as regular user (should fail with EACCES)
> +Permission denied
> +
> +# Setting v2 policy as regular user without key already added (should fail with ENOKEY)
> +SCRATCH_MNT/dir: failed to set encryption policy: Required key not available
> +# Adding v2 policy key as regular user (should succeed)
> +Added encryption key with identifier 69b2f6edeee720cce0577937eb8a6751
> +# Setting v2 policy as regular user with key added (should succeed)
> +# Getting v2 policy as regular user (should succeed)
> +Encryption policy for SCRATCH_MNT/dir:
> +	Policy version: 2
> +	Master key identifier: 69b2f6edeee720cce0577937eb8a6751
> +	Contents encryption mode: 1 (AES-256-XTS)
> +	Filenames encryption mode: 4 (AES-256-CTS)
> +	Flags: 0x02
> +# Creating encrypted file as regular user (should succeed)
> +# Removing v2 policy key as regular user (should succeed)
> +Removed encryption key with identifier 69b2f6edeee720cce0577937eb8a6751
> +
> +# Testing user key quota
> +Added encryption key
> +Added encryption key
> +Added encryption key
> +Added encryption key
> +Added encryption key
> +Error adding encryption key: Disk quota exceeded
> +
> +# Adding key as root
> +Added encryption key with identifier 69b2f6edeee720cce0577937eb8a6751
> +# Getting key status as regular user
> +Present (user_count=1)
> +# Removing key only added by another user (should fail with ENOKEY)
> +Error removing encryption key: Required key not available
> +# Setting v2 encryption policy with key only added by another user (should fail with ENOKEY)
> +SCRATCH_MNT/dir: failed to set encryption policy: Required key not available
> +# Adding second user of key
> +Added encryption key with identifier 69b2f6edeee720cce0577937eb8a6751
> +# Getting key status as regular user
> +Present (user_count=2, added_by_self)
> +# Setting v2 encryption policy as regular user
> +# Removing this user's claim to the key
> +Removed user's claim to encryption key with identifier 69b2f6edeee720cce0577937eb8a6751
> +# Getting key status as regular user
> +Present (user_count=1)
> +# Adding back second user of key
> +Added encryption key with identifier 69b2f6edeee720cce0577937eb8a6751
> +# Remove key for "all users", as regular user (should fail with EACCES)
> +Permission denied
> +Present (user_count=2, added_by_self)
> +# Remove key for "all users", as root
> +Removed encryption key with identifier 69b2f6edeee720cce0577937eb8a6751
> +Absent
> diff --git a/tests/generic/group b/tests/generic/group
> index cf2240ec..6d1ecf5a 100644
> --- a/tests/generic/group
> +++ b/tests/generic/group
> @@ -582,3 +582,4 @@
>  577 auto quick verity
>  578 auto quick rw clone
>  800 auto quick encrypt
> +801 auto quick encrypt
> -- 
> 2.23.0.700.g56cf767bdb-goog
> 

