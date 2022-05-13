Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 275AA526A71
	for <lists+linux-fscrypt@lfdr.de>; Fri, 13 May 2022 21:36:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383617AbiEMTgb (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Fri, 13 May 2022 15:36:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348000AbiEMTga (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Fri, 13 May 2022 15:36:30 -0400
Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1649EB0;
        Fri, 13 May 2022 12:36:28 -0700 (PDT)
Received: from cwcc.thunk.org (pool-108-7-220-252.bstnma.fios.verizon.net [108.7.220.252])
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 24DJa5h0007144
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 13 May 2022 15:36:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
        t=1652470567; bh=RFt/bdE39UxhuNW6KN2/50ftQSyeSKm2UXzuQnUBf6c=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To;
        b=nBB5W9uTLiDNXGXO+dcD5KS8qamuZANEZlRovaHg5ckMjYDDWRHrYXcjz25k2Csnv
         TFDZSoBwqUblsQFnnDJBo5Wz+P2ExAEqHSCrKavRhUh0CaSmG2UfJTCzCV6ohmZCjA
         OCQ/ReLDj6BmfFUddb4qCtTv9AKpn9IvrCFTVVylVwf0zJnzNTBLplZQB8rWwzRTDS
         /hgbC7RHdFPnsPOkivMWitoN66rgViLcIT0C3gEfTGwYqziViGsA/ifTYZ9JpSEZIe
         EHXq2Qk1xBEEJ1L4DkPZBGnXaV/HBVavxzxoF05Qi4F1jfluuS1sUN5xwrMwemyV65
         heJqxuGVIG2oQ==
Received: by cwcc.thunk.org (Postfix, from userid 15806)
        id 164D815C3F2A; Fri, 13 May 2022 15:36:05 -0400 (EDT)
Date:   Fri, 13 May 2022 15:36:05 -0400
From:   "Theodore Ts'o" <tytso@mit.edu>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     linux-fscrypt@vger.kernel.org, linux-ext4@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net,
        Lukas Czerner <lczerner@redhat.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Jeff Layton <jlayton@kernel.org>
Subject: Re: [PATCH v2 0/7] test_dummy_encryption fixes and cleanups
Message-ID: <Yn6zJR2peMo5hIcF@mit.edu>
References: <20220501050857.538984-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220501050857.538984-1-ebiggers@kernel.org>
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,DKIM_INVALID,
        DKIM_SIGNED,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Sat, Apr 30, 2022 at 10:08:50PM -0700, Eric Biggers wrote:
> We can either take all these patches through the fscrypt tree, or we can
> take them in multiple cycles as follows:
> 
>     1. patch 1 via ext4, patch 2 via f2fs, patch 3-4 via fscrypt
>     2. patch 5 via ext4, patch 6 via f2fs
>     3. patch 7 via fscrypt
> 
> Ted and Jaegeuk, let me know what you prefer.

In order to avoid patch conflicts with other patch series, what I'd
prefer is to take them in multiple cycles.  I can take patch #1 in my
initial pull request to Linus, and then do a second pull request to
Linus with patch #5 post -rc1 or -rc2 (depending on when patches #3
and #4 hit Linus's tree).

Does that sound good?

						- Ted
