Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB04852CAD0
	for <lists+linux-fscrypt@lfdr.de>; Thu, 19 May 2022 06:22:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233486AbiESEWs (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 19 May 2022 00:22:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233438AbiESEWq (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 19 May 2022 00:22:46 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45E1A1054F;
        Wed, 18 May 2022 21:22:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D96586198B;
        Thu, 19 May 2022 04:22:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0FF3EC34100;
        Thu, 19 May 2022 04:22:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652934163;
        bh=/bcE5LkGFGQyYcHfHloz0vKZmPOV68+PsIFfeAHd8rg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=RP1iR1BijUCPxAfKXE+BM2qMy8gvEiL7bp4o2p6XaAruCp/vvBL7SC8YEPUHGh3dW
         KWR/0ZwuUIlvuHmisTC3CELfLDTu5pMjrJlXy8/Dfb55nmihWqk2cnuqSyHWkwZoPG
         inu86Y04K1Cy9lfIat4BS1L5n76A5wcp8mT7olglghllO5wBJsFuQLcMteoQAf1PSW
         lHNVQnwDBnN/QbffiJmhZHdEMiN/8hOl9BNCpRmjWTr4fp2neje2y4ZdaaYc/OCqLD
         vig5HNVRh8lBD4v+HFJ8rxVROiXqRlLATy6hU9no7VYeTjJGua+P0S4RbuhPbXD22X
         xthjmoq1uMTKA==
Date:   Wed, 18 May 2022 21:22:41 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     "zhangjianhua (E)" <chris.zjh@huawei.com>
Cc:     tytso@mit.edu, linux-fscrypt@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH -next v2] fs-verity: Use struct_size() helper in
 enable_verity()
Message-ID: <YoXGEckfSNWKj2oT@sol.localdomain>
References: <20220519022450.2434483-1-chris.zjh@huawei.com>
 <YoW0HG+Nbg681yWL@sol.localdomain>
 <YoW25wrIAiRVifMi@sol.localdomain>
 <e030eaf6-0b6b-7685-c5b6-fd0b57aea600@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e030eaf6-0b6b-7685-c5b6-fd0b57aea600@huawei.com>
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

[Please use reply all, not just reply!]

On Thu, May 19, 2022 at 11:54:48AM +0800, zhangjianhua (E) wrote:
> Hi Eric
> 
> The warnings in commit message are from the build log in Jan 2022, and I
> find these sizeof are still here, so I submit
> 
> these two patches. I build the kernel just now and encounter the same
> situation with you, there are lots of warnings.
> 
> Maybe you are right, there should be some mechanism to solve this problem
> completely.
> 
> 

I've updated the commit message and applied this patch, but not the other one,
as the other one wasn't actually dealing with a variable length which made it
pretty much pointless, as I mentioned.

If you'd like to look into making sparse enable this warning by default, I'd
certainly encourage you to do so.  But it looks like the warning itself could
use some more work.  It probably should only warn if the
sizeof(struct_with_flexible_array) is actually being added to another value, and
where that value is not a compile-time constant.

- Eric
