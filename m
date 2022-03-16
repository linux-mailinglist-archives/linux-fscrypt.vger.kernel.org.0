Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D79B14DB72B
	for <lists+linux-fscrypt@lfdr.de>; Wed, 16 Mar 2022 18:31:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234878AbiCPRcl (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 16 Mar 2022 13:32:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231330AbiCPRck (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 16 Mar 2022 13:32:40 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 706EB5B3E2;
        Wed, 16 Mar 2022 10:31:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1FDCEB81A2F;
        Wed, 16 Mar 2022 17:31:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D654C340E9;
        Wed, 16 Mar 2022 17:31:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647451883;
        bh=8s8c2XzMccqzeZhTMnK8TF2foipWG+CCj1AkGcuWzYg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=h6myKYRwY95wbRPmw/5OWDGsycVzVbLqjWddmZlFIl3BbfJLVsVR3jQTX/w9Pz5U/
         urcEfhX5mgfPgPP5NjIP1ROgrJvxDMzvfvBJlWfNk7J8H+W4rx/1UgouSdnzixpoCt
         Xfpczj9Xv8U97iVFQMhKA+gYA3UYHCOA6/me0t/VXlTAthT/CB+amB919I0cLVwZpI
         7HuwbnC2qPthWB4jeNjmHokLnGh9TEWe60UUhl0CE/9sfNJOzo/DrPWBuG3NqunfCr
         NI8w6WXxwwkd8pAW/IgqD5amAe6ZVUzgTzHPyfoIGsAwMB+ZsremuuTMdU2rSmAih+
         19Oj3e2G36Z3Q==
Date:   Wed, 16 Mar 2022 17:30:57 +0000
From:   Eric Biggers <ebiggers@kernel.org>
To:     Boris Burkov <boris@bur.io>
Cc:     fstests@vger.kernel.org, linux-fscrypt@vger.kernel.org,
        linux-btrfs@vger.kernel.org, kernel-team@fb.com
Subject: Re: [PATCH v7 5/5] generic: test fs-verity EFBIG scenarios
Message-ID: <YjIe0aPWeS/yonjM@gmail.com>
References: <cover.1647382272.git.boris@bur.io>
 <b07e3b6cc2d44310a0d46f68d2031ef60f3af4cc.1647382272.git.boris@bur.io>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b07e3b6cc2d44310a0d46f68d2031ef60f3af4cc.1647382272.git.boris@bur.io>
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Tue, Mar 15, 2022 at 03:16:01PM -0700, Boris Burkov wrote:
> btrfs, ext4, and f2fs cache the Merkle tree past EOF, which restricts
> the maximum file size beneath the normal maximum. Test the logic in
> those filesystems against files with sizes near the maximum.
> 
> To work properly, this does require some understanding of the practical
> but not standardized layout of the Merkle tree. This is a bit unpleasant
> and could make the test incorrect in the future, if the implementation
> changes. On the other hand, it feels quite useful to test this tricky
> edge case. It could perhaps be made more generic by adding some ioctls
> to let the file system communicate the maximum file size for a verity
> file or some information about the storage of the Merkle tree.
> 
> Signed-off-by: Boris Burkov <boris@bur.io>
> ---
>  common/verity         | 11 ++++++++
>  tests/generic/690     | 64 +++++++++++++++++++++++++++++++++++++++++++
>  tests/generic/690.out |  7 +++++
>  3 files changed, 82 insertions(+)
>  create mode 100755 tests/generic/690
>  create mode 100644 tests/generic/690.out

Reviewed-by: Eric Biggers <ebiggers@google.com>

- Eric
