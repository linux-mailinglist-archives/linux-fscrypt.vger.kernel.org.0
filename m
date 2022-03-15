Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC2324D90B7
	for <lists+linux-fscrypt@lfdr.de>; Tue, 15 Mar 2022 01:00:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234318AbiCOABz (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 14 Mar 2022 20:01:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235495AbiCOABy (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 14 Mar 2022 20:01:54 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C168522BCE;
        Mon, 14 Mar 2022 17:00:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 53E4D60DE2;
        Tue, 15 Mar 2022 00:00:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4882C340F4;
        Tue, 15 Mar 2022 00:00:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647302442;
        bh=V9rZpUcrvFvaKjiO5V6P52RJ72OurMRxOyKQ7AtAgBo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=AoUfmxbCyEEd+Pwb+WCQU4JIMOD/7ikYnqF6BVeY31eM0nvh6lSS446qZCOYvrnmc
         E+hND7Xz6iM5BQOwqgqMhFwbcgslDQA+sQTW3KczyzUtCuvuFXGKPN/6WJ4I/st/wr
         QRoegdY56G3+Bfw7gJ+SxkkHZN7PFcsBsN89VhnRJ6BsM/RiJ+2guR9rsyuXio7y+Y
         CSiB2x1M7gZBYSg8tOxNuDC0xozgB/xfkk0qRv2ATTEEdHdgXwVsFTOVL4Nu7Y6SA0
         NuKo/3EgHxiN1we0F+KMYhlpaeRJH4jZkKYGn3+zXSa34vt/6dS4fr2ilF5C6qxwX+
         qg/jsbVW8a/DQ==
Date:   Tue, 15 Mar 2022 00:00:41 +0000
From:   Eric Biggers <ebiggers@kernel.org>
To:     Boris Burkov <boris@bur.io>
Cc:     fstests@vger.kernel.org, linux-fscrypt@vger.kernel.org,
        linux-btrfs@vger.kernel.org, kernel-team@fb.com
Subject: Re: [PATCH v6 2/4] generic/574: corrupt btrfs merkle tree data
Message-ID: <Yi/XKWg9BWzmUGRy@gmail.com>
References: <cover.1644883592.git.boris@bur.io>
 <93f40b68c7beafb546e3cda328a78b2ab088d85c.1644883592.git.boris@bur.io>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <93f40b68c7beafb546e3cda328a78b2ab088d85c.1644883592.git.boris@bur.io>
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Mon, Feb 14, 2022 at 04:09:56PM -0800, Boris Burkov wrote:
> generic/574 has tests for corrupting the merkle tree data stored by the
> filesystem. Since btrfs uses a different scheme for storing this data,
> the existing logic for corrupting it doesn't work out of the box. Adapt
> it to properly corrupt btrfs merkle items.
> 
> This test relies on the btrfs implementation of fsverity in the patch:
> btrfs: initial fsverity support
> 
> and on btrfs-corrupt-block for corruption in the patches titled:
> btrfs-progs: corrupt generic item data with btrfs-corrupt-block
> btrfs-progs: expand corrupt_file_extent in btrfs-corrupt-block
> 
> Signed-off-by: Boris Burkov <boris@bur.io>
> ---
>  common/verity     | 18 ++++++++++++++++++
>  tests/generic/574 |  1 +
>  2 files changed, 19 insertions(+)
> 
> diff --git a/common/verity b/common/verity
> index eec8ae72..07d9d3fe 100644
> --- a/common/verity
> +++ b/common/verity
> @@ -322,6 +322,24 @@ _fsv_scratch_corrupt_merkle_tree()
>  		(( offset += ($(_get_filesize $file) + 65535) & ~65535 ))
>  		_fsv_scratch_corrupt_bytes $file $offset
>  		;;
> +	btrfs)
> +		local ino=$(stat -c '%i' $file)
> +		_scratch_unmount
> +		local byte=""
> +		while read -n 1 byte; do
> +			if [ -z $byte ]; then
> +				break
> +			fi

'[ -z $byte ]' could use quotes around $byte.  But isn't that check unneeded at
all, given that 'read' will fail when EOF is reached?

- Eric
