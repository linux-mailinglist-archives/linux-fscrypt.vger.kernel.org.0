Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F01491F7E05
	for <lists+linux-fscrypt@lfdr.de>; Fri, 12 Jun 2020 22:20:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726358AbgFLUUJ (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Fri, 12 Jun 2020 16:20:09 -0400
Received: from outgoing-auth-1.mit.edu ([18.9.28.11]:59320 "EHLO
        outgoing.mit.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726307AbgFLUUJ (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Fri, 12 Jun 2020 16:20:09 -0400
Received: from callcc.thunk.org (pool-100-0-195-244.bstnma.fios.verizon.net [100.0.195.244])
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 05CKK3HE025278
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 12 Jun 2020 16:20:04 -0400
Received: by callcc.thunk.org (Postfix, from userid 15806)
        id D7FF342026D; Fri, 12 Jun 2020 16:20:03 -0400 (EDT)
Date:   Fri, 12 Jun 2020 16:20:03 -0400
From:   "Theodore Y. Ts'o" <tytso@mit.edu>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     linux-ext4@vger.kernel.org, linux-fscrypt@vger.kernel.org
Subject: Re: [xfstests-bld PATCH] test-appliance: exclude ext4/023 and
 ext4/028 from encrypt config
Message-ID: <20200612202003.GD2863913@mit.edu>
References: <20200603215457.146447-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200603215457.146447-1-ebiggers@kernel.org>
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Wed, Jun 03, 2020 at 02:54:57PM -0700, Eric Biggers wrote:
> From: Eric Biggers <ebiggers@google.com>
> 
> In Linux 5.8, the test_dummy_encryption mount option will use v2
> encryption policies rather than v1 as it previously did.  This increases
> the size of the encryption xattr slightly, causing two ext4 tests to
> start failing due to xattr spillover.  Exclude these tests.
> 
> See kernel commit ed318a6cc0b6 ("fscrypt: support
> test_dummy_encryption=v2") for more details.
> 
> Signed-off-by: Eric Biggers <ebiggers@google.com>

Thanks, applied.

						- Ted
