Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 766BD4DB709
	for <lists+linux-fscrypt@lfdr.de>; Wed, 16 Mar 2022 18:21:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352867AbiCPRWg (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 16 Mar 2022 13:22:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350025AbiCPRWf (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 16 Mar 2022 13:22:35 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 219565AA6D;
        Wed, 16 Mar 2022 10:21:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B8BDA61830;
        Wed, 16 Mar 2022 17:21:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CEDAC340EE;
        Wed, 16 Mar 2022 17:21:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647451280;
        bh=BBu3AB8sHT8mVAZZC+EZVdPzsQ18ecXO9gqk4BKyoYA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=pfTNxFQGn3LN/aHxJjTMGWQ5Kf9FE4/qIDzRLJrhA/ZhOqwUQLoT6zF6GItLM67XU
         t+phHK+elXG1GqCQE8iE9b9ZgulhRC2EM80jr1KU7Rc+4yXtTa2J+g4qVHLhPSNPvQ
         mOuLfph6n5+31+izAVWQ89xlcvXP65fKupx4YXkByXKTJIpTAQPPUzDnWt3NkucumO
         OdaAW/G5YRn88MkSgNTkJ80/vIeEhk26dMWoO9iDi2spjUOetDJ/DGF4+gp3mr2SKv
         iRQ4pPOFKV7J6+/WHnpnKBR62sClkXn8A1cqcIrLI2VbXbUefqQll+ja5RqxoFrOcE
         +e79fQxVZxw8A==
Date:   Wed, 16 Mar 2022 17:21:18 +0000
From:   Eric Biggers <ebiggers@kernel.org>
To:     Boris Burkov <boris@bur.io>
Cc:     fstests@vger.kernel.org, linux-fscrypt@vger.kernel.org,
        linux-btrfs@vger.kernel.org, kernel-team@fb.com
Subject: Re: [PATCH v7 1/5] verity: require corruption functionality
Message-ID: <YjIcjiHLwTENvqZe@gmail.com>
References: <cover.1647382272.git.boris@bur.io>
 <73ea99df928e64baf172fa38a0648fb21494e864.1647382272.git.boris@bur.io>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <73ea99df928e64baf172fa38a0648fb21494e864.1647382272.git.boris@bur.io>
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Tue, Mar 15, 2022 at 03:15:57PM -0700, Boris Burkov wrote:
> Corrupting ext4 and f2fs relies on xfs_io fiemap. Btrfs corruption
> testing will rely on a btrfs specific corruption utility. Add the
> ability to require corruption functionality to make this properly
> modular. To start, just check for fiemap, as that is needed
> universally for _fsv_scratch_corrupt_bytes.
> 
> Signed-off-by: Boris Burkov <boris@bur.io>
> ---
>  common/verity     | 6 ++++++
>  tests/generic/574 | 1 +
>  tests/generic/576 | 1 +
>  3 files changed, 8 insertions(+)
> 
> diff --git a/common/verity b/common/verity
> index 38eea157..1afe4a82 100644
> --- a/common/verity
> +++ b/common/verity
> @@ -141,6 +141,12 @@ _require_fsverity_dump_metadata()
>  	_fail "Unexpected output from 'fsverity dump_metadata': $(<"$tmpfile")"
>  }
>  
> +# Check for userspace tools needed to corrupt verity data or metadata.
> +_require_fsverity_corruption()
> +{
> +       _require_xfs_io_command "fiemap"
> +}
> +
>  _scratch_mkfs_verity()
>  {
>  	case $FSTYP in
> diff --git a/tests/generic/574 b/tests/generic/574
> index 882baa21..17fdea52 100755
> --- a/tests/generic/574
> +++ b/tests/generic/574
> @@ -28,6 +28,7 @@ _cleanup()
>  _supported_fs generic
>  _require_scratch_verity
>  _disable_fsverity_signatures
> +_require_fsverity_corruption
>  
>  _scratch_mkfs_verity &>> $seqres.full
>  _scratch_mount
> diff --git a/tests/generic/576 b/tests/generic/576
> index 82fbdd71..d3e0a2d6 100755
> --- a/tests/generic/576
> +++ b/tests/generic/576
> @@ -28,6 +28,7 @@ _supported_fs generic
>  _require_scratch_verity
>  _require_scratch_encryption
>  _require_command "$KEYCTL_PROG" keyctl
> +_require_fsverity_corruption
>  _disable_fsverity_signatures
>  
>  _scratch_mkfs_encrypted_verity &>> $seqres.full

Reviewed-by: Eric Biggers <ebiggers@google.com>

- Eric
