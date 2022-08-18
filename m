Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2B2C4599091
	for <lists+linux-fscrypt@lfdr.de>; Fri, 19 Aug 2022 00:33:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244156AbiHRWca (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 18 Aug 2022 18:32:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234758AbiHRWc3 (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 18 Aug 2022 18:32:29 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00B24D4BCD;
        Thu, 18 Aug 2022 15:32:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6AA66616F2;
        Thu, 18 Aug 2022 22:32:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF320C433D6;
        Thu, 18 Aug 2022 22:32:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660861947;
        bh=g6D47osMLYcKv/4ZuafDlLlPCxOG8yG9jbSFs8PGmAg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=VntvFwVCAU5qVYoVG8ApFooSFzssmsyxgrmqUOqUl0IOSM0awJBn1adpuQcQ9grgH
         nx9Q31D9ZbKQlFIvSTE6EbnZikMjj9rVZXXJhLWfr2hgoaLanovm/tM0eUM1/qUnJt
         ej7oJ2fQ11WqV60Ww4H5OXglFHkQKD/bg9BkBzLhKSo2lHaMI0HqYPD0aoiC/Jdniu
         hYiB9zVShMhNSJRMPqxKIg45Eagid5ol8Iw8hOv5+XMYTL3AQ6+R6hKbusswBrCxnP
         LaYpkWXijfrlB59gQTImgUM+NCGv74sjHEHNW9uF+LEogj0DM1yWknbbWDdH3f3acg
         oI54fkoENpGhA==
Date:   Thu, 18 Aug 2022 15:32:26 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Boris Burkov <boris@bur.io>
Cc:     linux-btrfs@vger.kernel.org, linux-fscrypt@vger.kernel.org,
        fstests@vger.kernel.org
Subject: Re: [PATCH v3] fstests: add btrfs fs-verity send/recv test
Message-ID: <Yv69+v8lF6DNKZX7@sol.localdomain>
References: <e1e77ce5d7277b235e48adc8daf00a0dc0ae36e9.1660860807.git.boris@bur.io>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e1e77ce5d7277b235e48adc8daf00a0dc0ae36e9.1660860807.git.boris@bur.io>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
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

Looks good,

Reviewed-by: Eric Biggers <ebiggers@google.com>

- Eric
