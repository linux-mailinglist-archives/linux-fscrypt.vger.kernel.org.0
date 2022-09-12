Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7CBB65B5286
	for <lists+linux-fscrypt@lfdr.de>; Mon, 12 Sep 2022 03:37:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229531AbiILBhF (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Sun, 11 Sep 2022 21:37:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229446AbiILBhE (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Sun, 11 Sep 2022 21:37:04 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D836424944;
        Sun, 11 Sep 2022 18:37:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 91862B80B49;
        Mon, 12 Sep 2022 01:37:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D795EC433C1;
        Mon, 12 Sep 2022 01:36:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1662946621;
        bh=ktWUICUQqI7TXXDui89I6v4jFPMjjS1A6iIaGOULTbo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=U9sPjmi4Y/7/CrEDLA8NgkkQloydrG58flyH0FudjQa3wrxnW4nWIwlJtHQDLbFNs
         /sr6U6PuOAWO/Da2yBV38rEbLo78VjzxvBOqXf4k4Q52UV4eUG0kObb29jnR1D0cWZ
         pawnAVym1DbsjSBd57UGy9S/eZZOUZ9+MIFcI8nLZMQDdEQ14Yq0FFe3qWDDFmie6I
         qG+8hhGiTsRqPd8sJ3gOZcpuwXCbkgTgtXXhH+pVON10K9DNYWAHV3HR9xzhuV1aT6
         oGkMNFVlSnxX6nn9AifSC7Iaa/UUpCBXxLd/GPgRwvo16a/vU4RXPQHvt6P5NRwXs2
         LqqtZP0OwxKnA==
Date:   Sun, 11 Sep 2022 20:36:54 -0500
From:   Eric Biggers <ebiggers@kernel.org>
To:     Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
Cc:     "Theodore Y. Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>, Chris Mason <clm@fb.com>,
        Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>, linux-fscrypt@vger.kernel.org,
        linux-btrfs@vger.kernel.org, kernel-team@fb.com,
        Omar Sandoval <osandov@osandov.com>
Subject: Re: [PATCH v2 16/20] btrfs: Add new FEATURE_INCOMPAT_FSCRYPT feature
 flag.
Message-ID: <Yx6NNiHEbAKAdZ2E@quark>
References: <cover.1662420176.git.sweettea-kernel@dorminy.me>
 <dc78a8b7148d5b611008e722617310b6be941cdc.1662420176.git.sweettea-kernel@dorminy.me>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <dc78a8b7148d5b611008e722617310b6be941cdc.1662420176.git.sweettea-kernel@dorminy.me>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Mon, Sep 05, 2022 at 08:35:31PM -0400, Sweet Tea Dorminy wrote:
> From: Omar Sandoval <osandov@osandov.com>
> 
> As fscrypt files will be incompatible with older filesystem versions,
> new filesystems should be created with an incompat flag for fscrypt.
> 
> Signed-off-by: Omar Sandoval <osandov@osandov.com>
> Signed-off-by: Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
> ---
>  fs/btrfs/ctree.h           | 6 ++++--
>  include/uapi/linux/btrfs.h | 1 +
>  2 files changed, 5 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
> index 38927a867028..e8d000fcc85d 100644
> --- a/fs/btrfs/ctree.h
> +++ b/fs/btrfs/ctree.h
> @@ -330,7 +330,8 @@ static_assert(sizeof(struct btrfs_super_block) == BTRFS_SUPER_INFO_SIZE);
>  	 BTRFS_FEATURE_INCOMPAT_METADATA_UUID	|	\
>  	 BTRFS_FEATURE_INCOMPAT_RAID1C34	|	\
>  	 BTRFS_FEATURE_INCOMPAT_ZONED		|	\
> -	 BTRFS_FEATURE_INCOMPAT_EXTENT_TREE_V2)
> +	 BTRFS_FEATURE_INCOMPAT_EXTENT_TREE_V2	|	\
> +	 BTRFS_FEATURE_INCOMPAT_FSCRYPT)

Shouldn't this flag be named "encrypt", to be consistent with the other
filesystems?

- Eric
