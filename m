Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9C6894DCD69
	for <lists+linux-fscrypt@lfdr.de>; Thu, 17 Mar 2022 19:17:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237338AbiCQSSl (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 17 Mar 2022 14:18:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237495AbiCQSSE (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 17 Mar 2022 14:18:04 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 731C9221B99;
        Thu, 17 Mar 2022 11:16:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0AC07616EA;
        Thu, 17 Mar 2022 18:16:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FA66C340E9;
        Thu, 17 Mar 2022 18:16:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647541006;
        bh=dR63KUR/H3INyD1WHSPSWmrdk6XmAj8AqIgLzzEcbw4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=pxDxugqZcwANxpmNV9ovBFUV1c9eE01gsrtER73W4gCmgUl1uYbdU3U5tz/5PDuVI
         yCXqaDubknM4G/gPstaEy8BO55SH1OZpW8nFOa0Wcu8kxQHYg/Gv369+vEz8FSg9jM
         vyurWipa5BoPFhDP6A+7dFjMpLKUh3WbvaD0oEaQxf9JX4z+ezMrL1/+NxA8Zob9f6
         I/Xnl5AXlHU4EOnTY28IgBwhiO5nu+bPIADcWMg+NoyDu6Kuy4rFjpdNNhtk3EJqPO
         8z/QDokfPPw63YkmWnpL1nZm1DUHFQP5Cb1ZokFy0eJMUR4uVYNxzZFIayFV4I45ye
         FerPrPM+tyA9w==
Date:   Thu, 17 Mar 2022 18:16:45 +0000
From:   Eric Biggers <ebiggers@kernel.org>
To:     Boris Burkov <boris@bur.io>
Cc:     fstests@vger.kernel.org, linux-fscrypt@vger.kernel.org,
        linux-btrfs@vger.kernel.org, kernel-team@fb.com
Subject: Re: [PATCH v8 2/5] common/verity: support btrfs in generic fsverity
 tests
Message-ID: <YjN7Dc9aTD2FHTTO@gmail.com>
References: <cover.1647461985.git.boris@bur.io>
 <9c64fbf9ad37dc84a31caf91762edd64b33d59db.1647461985.git.boris@bur.io>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9c64fbf9ad37dc84a31caf91762edd64b33d59db.1647461985.git.boris@bur.io>
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Wed, Mar 16, 2022 at 01:25:12PM -0700, Boris Burkov wrote:
> generic/572-579 have tests for fsverity. Now that btrfs supports
> fsverity, make these tests function as well. For a majority of the tests
> that pass, simply adding the case to mkfs a btrfs filesystem with no
> extra options is sufficient.
> 
> However, generic/574 has tests for corrupting the merkle tree itself.
> Since btrfs uses a different scheme from ext4 and f2fs for storing this
> data, the existing logic for corrupting it doesn't work out of the box.
> Adapt it to properly corrupt btrfs merkle items.
> 
> 576 does not run because btrfs does not support transparent encryption.
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
>  common/btrfs  |  5 +++++
>  common/config |  1 +
>  common/verity | 23 +++++++++++++++++++++++
>  3 files changed, 29 insertions(+)

Reviewed-by: Eric Biggers <ebiggers@google.com>

- Eric
