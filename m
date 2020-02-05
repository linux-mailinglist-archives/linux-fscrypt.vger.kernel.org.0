Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2B23B15259F
	for <lists+linux-fscrypt@lfdr.de>; Wed,  5 Feb 2020 05:39:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727879AbgBEEjO (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Tue, 4 Feb 2020 23:39:14 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:54429 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727873AbgBEEjO (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Tue, 4 Feb 2020 23:39:14 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580877552;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=o/FSRn5ZgAGskL5aURpHxUHlcFZjDhPUKviiGyjuhIU=;
        b=ATLgBS77Xf6hm9Ebjy/YMiLfzhSsG6NPV8sc5FHS1z9uiK6T9lOAE1U7bCS8wwCtemzz0h
        NW2/zDc0U2jxgWJXHdBUmJSsFTtWcxKTW1HT6pMpx917r4GvS7VEINpgx+eNN4RzP2DXRa
        wr18JtOScOFPGPLAmSkJLbVpDJwtov4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-236-8UfdUb0nMQGsWY1CMSCuOQ-1; Tue, 04 Feb 2020 23:39:08 -0500
X-MC-Unique: 8UfdUb0nMQGsWY1CMSCuOQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BF3BFDB23;
        Wed,  5 Feb 2020 04:39:07 +0000 (UTC)
Received: from localhost (dhcp-12-196.nay.redhat.com [10.66.12.196])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3232C212C;
        Wed,  5 Feb 2020 04:39:06 +0000 (UTC)
Date:   Wed, 5 Feb 2020 12:39:05 +0800
From:   Murphy Zhou <xzhou@redhat.com>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     fstests@vger.kernel.org, linux-fscrypt@vger.kernel.org,
        keyrings@vger.kernel.org, Murphy Zhou <xzhou@redhat.com>
Subject: Re: [PATCH] generic/581: try to avoid flakiness in keys quota test
Message-ID: <20200205043905.xpp5rniupbi4j7qa@xzhoux.usersys.redhat.com>
References: <20200129004251.133747-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200129004251.133747-1-ebiggers@kernel.org>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Tue, Jan 28, 2020 at 04:42:51PM -0800, Eric Biggers wrote:
> From: Eric Biggers <ebiggers@google.com>
> 
> generic/581 passes for me, but Murphy Zhou reported that it started
> failing for him.  The part that failed is the part that sets the key
> quota to the fsgqa user's current number of keys plus 5, then tries to
> add 6 filesystem encryption keys as the fsgqa user.  Adding the 6th key
> unexpectedly succeeded.

Ack. This patch fixed generic/581 failure on my side.

Thanks Eric!

Murphy

> 
> What I think is happening is that because the kernel's keys subsystem
> garbage-collects keys asynchronously, the quota may be freed up later
> than expected after removing fscrypt keys.  Thus the test is flaky.
> 
> It would be nice to fix this in the kernel, but unfortunately there
> doesn't seem to be an easy fix, and the keys subsystem has always worked
> this way.  And it seems unlikely to cause real-world problems, as the
> keys quota really just exists to prevent denial-of-service attacks.
> 
> So, for now just try to make the test more reliable by:
> 
> (1) Reduce the scope of the modified keys quota to just the part of the
>     test that needs it.
> (2) Before getting the current number of keys for the purpose of setting
>     the quota, wait for any invalidated keys to be garbage-collected.
> 
> Tested with a kernel that has a 1 second sleep hacked into the beginning
> of key_garbage_collector().  With that, this test fails before this
> patch and passes afterwards.
> 
> Reported-by: Murphy Zhou <xzhou@redhat.com>
> Signed-off-by: Eric Biggers <ebiggers@google.com>
> ---
>  tests/generic/581 | 29 +++++++++++++++++++++--------
>  1 file changed, 21 insertions(+), 8 deletions(-)
> 
> diff --git a/tests/generic/581 b/tests/generic/581
> index 89aa03c2..bc49eadc 100755
> --- a/tests/generic/581
> +++ b/tests/generic/581
> @@ -45,14 +45,6 @@ _require_scratch_encryption -v 2
>  _scratch_mkfs_encrypted &>> $seqres.full
>  _scratch_mount
>  
> -# Set the fsgqa user's key quota to their current number of keys plus 5.
> -orig_keys=$(_user_do "awk '/^[[:space:]]*$(id -u fsgqa):/{print \$4}' /proc/key-users | cut -d/ -f1")
> -: ${orig_keys:=0}
> -echo "orig_keys=$orig_keys" >> $seqres.full
> -orig_maxkeys=$(</proc/sys/kernel/keys/maxkeys)
> -keys_to_add=5
> -echo $((orig_keys + keys_to_add)) > /proc/sys/kernel/keys/maxkeys
> -
>  dir=$SCRATCH_MNT/dir
>  
>  raw_key=""
> @@ -98,6 +90,24 @@ _user_do_rm_enckey $SCRATCH_MNT $keyid
>  
>  _scratch_cycle_mount	# Clear all keys
>  
> +# Wait for any invalidated keys to be garbage-collected.
> +i=0
> +while grep -E -q '^[0-9a-f]+ [^ ]*i[^ ]*' /proc/keys; do
> +	if ((++i >= 20)); then
> +		echo "Timed out waiting for invalidated keys to be GC'ed" >> $seqres.full
> +		break
> +	fi
> +	sleep 0.5
> +done
> +
> +# Set the user key quota to the fsgqa user's current number of keys plus 5.
> +orig_keys=$(_user_do "awk '/^[[:space:]]*$(id -u fsgqa):/{print \$4}' /proc/key-users | cut -d/ -f1")
> +: ${orig_keys:=0}
> +echo "orig_keys=$orig_keys" >> $seqres.full
> +orig_maxkeys=$(</proc/sys/kernel/keys/maxkeys)
> +keys_to_add=5
> +echo $((orig_keys + keys_to_add)) > /proc/sys/kernel/keys/maxkeys
> +
>  echo
>  echo "# Testing user key quota"
>  for i in `seq $((keys_to_add + 1))`; do
> @@ -106,6 +116,9 @@ for i in `seq $((keys_to_add + 1))`; do
>  	    | sed 's/ with identifier .*$//'
>  done
>  
> +# Restore the original key quota.
> +echo "$orig_maxkeys" > /proc/sys/kernel/keys/maxkeys
> +
>  rm -rf $dir
>  echo
>  _user_do "mkdir $dir"
> -- 
> 2.25.0.341.g760bfbb309-goog
> 

