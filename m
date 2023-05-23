Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8790A70D1C2
	for <lists+linux-fscrypt@lfdr.de>; Tue, 23 May 2023 04:50:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232622AbjEWCuL (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 22 May 2023 22:50:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229605AbjEWCuK (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 22 May 2023 22:50:10 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C93CCA;
        Mon, 22 May 2023 19:50:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B552C62E36;
        Tue, 23 May 2023 02:50:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF33BC433D2;
        Tue, 23 May 2023 02:50:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1684810209;
        bh=CzakUcJHhCSYBooe6gFoQyfZa+C4bAclSd0YXYcgfWE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=bKq4Pz1DLcQPqnPwxXCXYhZykp4/CmTjQLJ92OFeA/UaXsqQiMIRfDAByLhqZN3gK
         v0mR71rUOX2G/mOLRAnxTLAUy+sVGl8/AfWuKE6603vVcoi2sJ2l9jwxxkdtvDLukh
         RbXwAqRVG2kUc+2C8eSAcZRd3Aw+K7BkbM1HRFbzfIGgm8vvw7gGsz3R/OQlTXDz0e
         aTYHnGXGxTpTtS8wmjYhhwnlePlZtkjfOGFycS0kkQyLJG74gW+PttVV5gcbz340a4
         g3NlKUHZ0qzK9Yg1ogSi9zsPdzolnViUQoqh1JI1I308DWO8sJxNUjhl9bS4IGz5HX
         BXNZJeGr8Dy3A==
Date:   Tue, 23 May 2023 02:50:07 +0000
From:   Eric Biggers <ebiggers@kernel.org>
To:     Kees Cook <kees@kernel.org>
Cc:     Kees Cook <keescook@chromium.org>,
        "Theodore Y. Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        "Gustavo A . R . Silva" <gustavoars@kernel.org>,
        linux-fscrypt@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-hardening@vger.kernel.org
Subject: Re: [PATCH] fscrypt: Replace 1-element array with flexible array
Message-ID: <20230523025007.GC3187780@google.com>
References: <20230522213924.never.119-kees@kernel.org>
 <20230522230206.GA3187780@google.com>
 <F340AF2B-C611-48FE-BCB6-C4FF45005409@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <F340AF2B-C611-48FE-BCB6-C4FF45005409@kernel.org>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Mon, May 22, 2023 at 06:23:06PM -0700, Kees Cook wrote:
> On May 22, 2023 4:02:06 PM PDT, Eric Biggers <ebiggers@kernel.org> wrote:
> >On Mon, May 22, 2023 at 02:39:28PM -0700, Kees Cook wrote:
> >> In the future, we can add annotations for the flexible array member
> >> "encrypted_path" to have a size determined by the "len" member.
> >
> >That seems unlikely, as 'struct fscrypt_symlink_data' is an on-disk data
> >structure.  The "len" field does not necessarily use CPU endianness, and before
> >being validated it might be greater than the size of the allocated space.
> 
> Oh yes, good point.
> 
> >I agree that it should use a flex array (and thanks for catching this one that I
> >had forgotten about...), but the above explanation seems wrong.
> 
> Shall I spin a v2?

Yes, please go ahead.

- Eric
