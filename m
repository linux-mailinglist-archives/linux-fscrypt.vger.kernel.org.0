Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C845C4D90A8
	for <lists+linux-fscrypt@lfdr.de>; Tue, 15 Mar 2022 00:58:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343782AbiCOAAA (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 14 Mar 2022 20:00:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234318AbiCOAAA (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 14 Mar 2022 20:00:00 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22E8ADFB2;
        Mon, 14 Mar 2022 16:58:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B8A2E61490;
        Mon, 14 Mar 2022 23:58:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08A89C340F4;
        Mon, 14 Mar 2022 23:58:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647302317;
        bh=NtTOrnIkHZ4Yy022O3tWqFeJXmUuftXrgC8FRBtEG9k=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=IWtViUrIjmZPiyq3+dtB5mMYXBlxyAMxKEyZ+vMjma6KdGOn/8oa6ZI0UmLKle0C3
         1QSA/0P5R68ms0LkfUkByMXIXJHI7hTYkBqJTIIlA/YyPVrd8oc8boo1Iu9SH+5dED
         Q61Wp2RZeL5ZZSJRgomyiqR2aHTtAT5y3cxtCcRqHv9AsJK0CMJGSNL4TSscYiOLP2
         gYs77b0c2xfgQ6Rrk2DYZQ4XT3H6X3KvJtFA0gi0iHuPoW1CQotnMeHL7N7WBxbtvM
         OcidgIcuSxE5tsLW12LvrQT1/sB4e4k4ORQ1YHzOnBIhOGEDZIxZPu+FCXh4Gr6Vow
         shBBx9yB1syXg==
Date:   Mon, 14 Mar 2022 23:58:35 +0000
From:   Eric Biggers <ebiggers@kernel.org>
To:     Boris Burkov <boris@bur.io>
Cc:     fstests@vger.kernel.org, linux-fscrypt@vger.kernel.org,
        linux-btrfs@vger.kernel.org, kernel-team@fb.com
Subject: Re: [PATCH v6 1/4] btrfs: test btrfs specific fsverity corruption
Message-ID: <Yi/Wq/e7qv0jcQIb@gmail.com>
References: <cover.1644883592.git.boris@bur.io>
 <de58122e6cb1712fa5304f0759b40b36351dfc36.1644883592.git.boris@bur.io>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <de58122e6cb1712fa5304f0759b40b36351dfc36.1644883592.git.boris@bur.io>
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Mon, Feb 14, 2022 at 04:09:55PM -0800, Boris Burkov wrote:
> diff --git a/common/verity b/common/verity
> index 38eea157..eec8ae72 100644
> --- a/common/verity
> +++ b/common/verity
> @@ -3,6 +3,8 @@
>  #
>  # Functions for setting up and testing fs-verity
>  
> +. common/btrfs

Why does common/btrfs need to be included here?

> +# Check for userspace tools needed to corrupt verity data or metadata.
> +_require_fsverity_corruption()
> +{
> +	_require_xfs_io_command "fiemap"
> +	if [ $FSTYP == "btrfs" ]; then
> +		_require_btrfs_corrupt_block
> +	fi
> +}

Which function(s), specifically, is this function a prerequisite for?  Based on
the name, it sounds like it would be a prerequisite for calling
_fsv_scratch_corrupt_bytes() and _fsv_scratch_corrupt_merkle_tree().  But that's
apparently not the case, seeing as generic/576 calls
_fsv_scratch_corrupt_bytes() but doesn't call _require_fsverity_corruption(),
and your new test btrfs/290 calls _require_fsverity_corruption() but doesn't
call either _fsv_scratch_corrupt_bytes() or _fsv_scratch_corrupt_merkle_tree().

So, the purpose of this function is unclear.

Perhaps it should be a prerequisite for all _fsv_scratch_corrupt*() functions,
and btrfs/290 should check for btrfs-corrupt-block directly?

- Eric
