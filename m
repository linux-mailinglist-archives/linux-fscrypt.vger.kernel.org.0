Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 23B254DCD6A
	for <lists+linux-fscrypt@lfdr.de>; Thu, 17 Mar 2022 19:17:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237360AbiCQSSl (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 17 Mar 2022 14:18:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237613AbiCQSSY (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 17 Mar 2022 14:18:24 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F026E221B9C;
        Thu, 17 Mar 2022 11:17:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8C2056164B;
        Thu, 17 Mar 2022 18:17:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDBD9C340E9;
        Thu, 17 Mar 2022 18:17:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647541027;
        bh=uwLGhppaM4EPBUsUUIBd1Eode8pLFd0Ih30CpHchp6s=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=NfybaHe/ONaEckdyIwIlWZyBGVgsoq9h0D+xp5CousgVM3VAYrOb5CKDtFk7t79rZ
         L0sWPFqvcUvZvb+32qtNnHyXyGFruBbYW+3owOu2sb+sVzZpV138yvCCUhikqnrHiR
         h0ov8nB56HIJWCKCPryTTgazN8/nGPNRTxam9jagCMkMtgeCcWmPwx+H8TqrFdXvhJ
         zmxG8ReBF1zhRvM8jd2R7WqrYAriexS9lODZzaykdqGsh3USVTQyCgljEAr1bn3o6k
         My9ZOwyberpboZ/VvOC+NErIjSbZm9A9F2PqHx/g42SNNt5JTxzXXYwvoc0qRND6G3
         IAljVpIZ2jZAA==
Date:   Thu, 17 Mar 2022 18:17:05 +0000
From:   Eric Biggers <ebiggers@kernel.org>
To:     Boris Burkov <boris@bur.io>
Cc:     fstests@vger.kernel.org, linux-fscrypt@vger.kernel.org,
        linux-btrfs@vger.kernel.org, kernel-team@fb.com
Subject: Re: [PATCH v8 5/5] generic: test fs-verity EFBIG scenarios
Message-ID: <YjN7ISqihkUTR0KD@gmail.com>
References: <cover.1647461985.git.boris@bur.io>
 <a49cc77ece554918995f3dac756b5551a50f71c9.1647461985.git.boris@bur.io>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a49cc77ece554918995f3dac756b5551a50f71c9.1647461985.git.boris@bur.io>
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Wed, Mar 16, 2022 at 01:25:15PM -0700, Boris Burkov wrote:
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
> 

Reviewed-by: Eric Biggers <ebiggers@google.com>

- Eric
