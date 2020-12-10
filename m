Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C39042D663D
	for <lists+linux-fscrypt@lfdr.de>; Thu, 10 Dec 2020 20:21:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388934AbgLJTU3 (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 10 Dec 2020 14:20:29 -0500
Received: from outgoing-auth-1.mit.edu ([18.9.28.11]:52256 "EHLO
        outgoing.mit.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2389053AbgLJTUZ (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 10 Dec 2020 14:20:25 -0500
Received: from callcc.thunk.org (pool-72-74-133-215.bstnma.fios.verizon.net [72.74.133.215])
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 0BAJJYRr005124
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 10 Dec 2020 14:19:35 -0500
Received: by callcc.thunk.org (Postfix, from userid 15806)
        id 48919420136; Thu, 10 Dec 2020 14:19:34 -0500 (EST)
Date:   Thu, 10 Dec 2020 14:19:34 -0500
From:   "Theodore Y. Ts'o" <tytso@mit.edu>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     linux-fscrypt@vger.kernel.org, Satya Tangirala <satyat@google.com>
Subject: Re: [xfstests-bld PATCH] android-xfstests: create /dev/fd on the
 Android device
Message-ID: <20201210191934.GT52960@mit.edu>
References: <20201209043305.77917-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201209043305.77917-1-ebiggers@kernel.org>
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Tue, Dec 08, 2020 at 08:33:05PM -0800, Eric Biggers wrote:
> From: Eric Biggers <ebiggers@google.com>
> 
> In order for bash process substitution (the syntax like "<(list)" or
> ">(list)") to work, /dev/fd has to be a symlink to /proc/self/fd.
> /dev/fd doesn't exist on Android, so create it if it's missing.
> 
> This fixes xfstest generic/576.
> 
> Signed-off-by: Eric Biggers <ebiggers@google.com>

Thanks, applied.

						- Ted
