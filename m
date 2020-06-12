Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5CC631F7E02
	for <lists+linux-fscrypt@lfdr.de>; Fri, 12 Jun 2020 22:19:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726307AbgFLUTY (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Fri, 12 Jun 2020 16:19:24 -0400
Received: from outgoing-auth-1.mit.edu ([18.9.28.11]:59149 "EHLO
        outgoing.mit.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726290AbgFLUTY (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Fri, 12 Jun 2020 16:19:24 -0400
Received: from callcc.thunk.org (pool-100-0-195-244.bstnma.fios.verizon.net [100.0.195.244])
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 05CKJJOg024969
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 12 Jun 2020 16:19:20 -0400
Received: by callcc.thunk.org (Postfix, from userid 15806)
        id AE86742026D; Fri, 12 Jun 2020 16:19:19 -0400 (EDT)
Date:   Fri, 12 Jun 2020 16:19:19 -0400
From:   "Theodore Y. Ts'o" <tytso@mit.edu>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     linux-fscrypt@vger.kernel.org
Subject: Re: [xfstests-bld PATCH] build-all: update rule to build
 fsverity-utils
Message-ID: <20200612201919.GC2863913@mit.edu>
References: <20200527211642.122200-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200527211642.122200-1-ebiggers@kernel.org>
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Wed, May 27, 2020 at 02:16:42PM -0700, Eric Biggers wrote:
> From: Eric Biggers <ebiggers@google.com>
> 
> To match the usual convention, the fsverity-utils Makefile now takes a
> PREFIX variable which defaults to /usr/local.
> 
> But xfstests-bld wants PREFIX=/usr, so set that.
> 
> Also don't explicitly build the 'all' target, since 'install' depends on
> it already.
> 
> Signed-off-by: Eric Biggers <ebiggers@google.com>

Thanks, applied.

						- Ted
