Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 44BB2521DDD
	for <lists+linux-fscrypt@lfdr.de>; Tue, 10 May 2022 17:13:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345351AbiEJPRQ (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Tue, 10 May 2022 11:17:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345885AbiEJPQ3 (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Tue, 10 May 2022 11:16:29 -0400
Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F2312415EF;
        Tue, 10 May 2022 07:53:45 -0700 (PDT)
Received: from cwcc.thunk.org (pool-108-7-220-252.bstnma.fios.verizon.net [108.7.220.252])
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 24AErZnc016713
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 10 May 2022 10:53:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
        t=1652194417; bh=Fnv249fYhc8awLEpKpIuokBw1LqlnSwBRge1pSiJuKI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To;
        b=mHIRvZ8l7TINnwyjTRv2rS1u4BTuYkQ0wHiJOtYLShj92jKOcMEeI7cBoWDsUqXPy
         6GZS2EKYWKtP9qcoXCryzwDQKZaglT8JqHqIdMHiT+2SFqKY4gIG8aZ43TlETy7vdx
         1IUOSDlGPVjxtbXEfDXXkdwPVjaGiAEAnURFj2RhvoHRQjA6jrvvJdC3fcp03HQiKR
         gkMNPztoC16aUuTBMOvqoiIBff44qKAFH5V6h+EkDxxXUMA9vVnOJjZ4PsWOXRLn7M
         dFR9Sk5uAVBRqj0ZnEN2/AvJyawfIrCL7Oee0CUF03YAoRG79fXxUs/YdARIF1OM8O
         L9pD/5FmCu2WQ==
Received: by cwcc.thunk.org (Postfix, from userid 15806)
        id 79F0015C3F0A; Tue, 10 May 2022 10:53:35 -0400 (EDT)
Date:   Tue, 10 May 2022 10:53:35 -0400
From:   "Theodore Ts'o" <tytso@mit.edu>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     fstests@vger.kernel.org, linux-fscrypt@vger.kernel.org,
        linux-ext4@vger.kernel.org, Lukas Czerner <lczerner@redhat.com>
Subject: Re: [xfstests PATCH 1/2] ext4/053: update the test_dummy_encryption
 tests
Message-ID: <Ynp8b+Gocx3A/NbW@mit.edu>
References: <20220501051928.540278-1-ebiggers@kernel.org>
 <20220501051928.540278-2-ebiggers@kernel.org>
 <Ym/Sk7D17iCeQIJa@mit.edu>
 <YnASjrPbudBXCYfK@sol.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YnASjrPbudBXCYfK@sol.localdomain>
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,DKIM_INVALID,
        DKIM_SIGNED,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Mon, May 02, 2022 at 10:19:10AM -0700, Eric Biggers wrote:
> 
> We could gate them on the kernel version, similar to the whole ext4/053 which
> already only runs on kernel version 5.12.  (Kernel versions checks suck, but
> maybe it's the right choice for this very-nit-picky test.)  Alternatively, I
> could just backport "ext4: only allow test_dummy_encryption when supported" to
> 5.15, which would be the only relevant LTS kernel version.

If we don't need the "only allow test_dummy_encryption when supported"
in any Android, Distro, or LTS kernel --- which seems to be a
reasonable assumption, that seems to be OK.  Lukas, do you agree?

In the long term I suspect there will be times when we want to
backport mount option handling changes to older kernels, and we're
going to be hit this issue again, but as the saying goes, "sufficient
unto the day is the evil thereof".

     	 				- Ted
				
