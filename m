Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D1AC599AAB
	for <lists+linux-fscrypt@lfdr.de>; Fri, 19 Aug 2022 13:18:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348762AbiHSLOe (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Fri, 19 Aug 2022 07:14:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348267AbiHSLOd (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Fri, 19 Aug 2022 07:14:33 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F9D5CCE1A;
        Fri, 19 Aug 2022 04:14:31 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id C002D3F8CD;
        Fri, 19 Aug 2022 11:14:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1660907669;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Z1GDxJbx+KB/qA4pxm9HVh5vMJZlaEZx8YtS83ZfxTg=;
        b=P541Xi9aO3pFkCcmOMJ6PLo+o9b1TBwcys/jYx0gp7NEL6OvWgMWdBYn++wg6Sj+gNVWK9
        R/ZNvZB0IiXeBwcfdxq6KwKTWEWPVOEqD/tQGx8X7nCEqRiRaJMvE2bfs5XTd4YPaD8qMC
        4w0yUX3DvgCw30kP3xth9u5V9dtPI58=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1660907669;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Z1GDxJbx+KB/qA4pxm9HVh5vMJZlaEZx8YtS83ZfxTg=;
        b=/GhM+MayMH8BLSN1+0urh0zTPlB3pozih4aK0+YFpPyS2jHIaQ7FmIQO85zIbMlE8qi5Fs
        uFTZDsMwgE2/MZAQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 7BA9813AE9;
        Fri, 19 Aug 2022 11:14:29 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id fLc7HZVw/2JkKQAAMHmgww
        (envelope-from <dsterba@suse.cz>); Fri, 19 Aug 2022 11:14:29 +0000
Date:   Fri, 19 Aug 2022 13:09:17 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Boris Burkov <boris@bur.io>
Cc:     linux-btrfs@vger.kernel.org, linux-fscrypt@vger.kernel.org,
        fstests@vger.kernel.org
Subject: Re: [PATCH v3] fstests: add btrfs fs-verity send/recv test
Message-ID: <20220819110917.GQ13489@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Boris Burkov <boris@bur.io>,
        linux-btrfs@vger.kernel.org, linux-fscrypt@vger.kernel.org,
        fstests@vger.kernel.org
References: <e1e77ce5d7277b235e48adc8daf00a0dc0ae36e9.1660860807.git.boris@bur.io>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e1e77ce5d7277b235e48adc8daf00a0dc0ae36e9.1660860807.git.boris@bur.io>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Thu, Aug 18, 2022 at 03:16:30PM -0700, Boris Burkov wrote:
> Test btrfs send/recv support for fs-verity. Includes tests for
> signatures, salts, and interaction with chmod/caps. The last of those is
> to ensure the various features that go in during inode_finalize interact
> properly.
> 
> This depends on the kernel patch adding support for send:
> btrfs: send: add support for fs-verity
> 
> And the btrfs-progs patch adding support for recv:
> btrfs-progs: receive: add support for fs-verity
> 
> Signed-off-by: Boris Burkov <boris@bur.io>
> ---
> Changes for v3:
> - commit a few things from v2 that I left unstaged (277 in output,
>   true/false)
> Changes for v2:
> - btrfs/271 -> btrfs/277
> - YOUR NAME HERE -> Meta
> - change 0/1 to false/true
> - change drop caches to cycle mount
> - get rid of unneeded _require_test
> - compare file contents
> 
>  tests/btrfs/277     | 115 ++++++++++++++++++++++++++++++++++++++++++++
>  tests/btrfs/277.out |  59 +++++++++++++++++++++++
>  2 files changed, 174 insertions(+)
>  create mode 100755 tests/btrfs/277
>  create mode 100644 tests/btrfs/277.out
> 
> diff --git a/tests/btrfs/277 b/tests/btrfs/277
> new file mode 100755
> index 00000000..251e2818
> --- /dev/null
> +++ b/tests/btrfs/277
> @@ -0,0 +1,115 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (c) 2022 Meta, Inc.  All Rights Reserved.
> +#
> +# FS QA Test 277
> +#
> +# Test sendstreams involving fs-verity enabled files.
> +#
> +. ./common/preamble
> +_begin_fstest auto quick verity send
> +
> +# Override the default cleanup function.
> +_cleanup()
> +{
> +	cd /
> +	_restore_fsverity_signatures
> +	rm -r -f $tmp.*
> +}
> +
> +# Import common functions.
> +. ./common/filter
> +. ./common/verity
> +
> +# real QA test starts here
> +
> +# Modify as appropriate.
> +_supported_fs btrfs
> +_require_scratch_verity
> +_require_fsverity_builtin_signatures
> +_require_command "$SETCAP_PROG" setcap
> +_require_command "$GETCAP_PROG" getcap
> +
> +subv=$SCRATCH_MNT/subv
> +fsv_file=$subv/file.fsv
> +keyfile=$tmp.key.pem
> +certfile=$tmp.cert.pem
> +certfileder=$tmp.cert.der
> +sigfile=$tmp.sig
> +stream=$tmp.fsv.ss
> +
> +_test_send_verity() {
> +	local sig=$1
> +	local salt=$2
> +	local extra_args=""
> +
> +	_scratch_mkfs >> $seqres.full
> +	_scratch_mount
> +	echo -e "\nverity send/recv test: sig: $sig salt: $salt"
> +	_disable_fsverity_signatures
> +
> +	echo "create subvolume"
> +	$BTRFS_UTIL_PROG subv create $subv >> $seqres.full

Please use full name of subcommands, ie. 'subvolume'
