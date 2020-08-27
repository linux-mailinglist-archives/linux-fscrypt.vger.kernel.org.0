Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 06D26253B33
	for <lists+linux-fscrypt@lfdr.de>; Thu, 27 Aug 2020 02:53:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726790AbgH0Axo (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 26 Aug 2020 20:53:44 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:52498 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726794AbgH0Axo (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 26 Aug 2020 20:53:44 -0400
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 07R0VoAH055017;
        Wed, 26 Aug 2020 20:53:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 mime-version : content-transfer-encoding; s=pp1;
 bh=4u/SpMLMYYE43GXoGBoJmgF2Y5+0iPOKMNpyG4eAk5k=;
 b=QrCG6QNLewtqbB/KdYKiqsPj40Mm2BuTzGOfGnDQ9dyZs4tY3TrDKi2AYgh+QnVdijkk
 xhWg9Pv7hplkyWb7Gd+VIY2Rt5E33qhigXoFxYstcNIQlySmKqBFpiivtfG6r7A13hTX
 yioZYw4rPSNq/xymWLWutW7+bTXlkQd/v0YIzRPXnLzLwtNMb4P9LJqEcanmnRE2JELl
 5JKTtEs/yFQrwzzZBMAydoM6ACNhVLrMy/7omkJ6frjMj4r8tkCCIXI4ilJTVpQmvMu+
 260sCshYvIcrKGxajtqA2qc0c91BYNnYeDYNIsiWpBgOFmE+zUJSUsUUkU7vI3ryQQds gg== 
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0b-001b2d01.pphosted.com with ESMTP id 33625f8q76-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 26 Aug 2020 20:53:39 -0400
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 07R0qSqE010281;
        Thu, 27 Aug 2020 00:53:38 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma04ams.nl.ibm.com with ESMTP id 336124r2ct-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 27 Aug 2020 00:53:37 +0000
Received: from d06av24.portsmouth.uk.ibm.com (mk.ibm.com [9.149.105.60])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 07R0q5YO58458398
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 27 Aug 2020 00:52:05 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CB81142049;
        Thu, 27 Aug 2020 00:53:35 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 92DFC42041;
        Thu, 27 Aug 2020 00:53:34 +0000 (GMT)
Received: from li-f45666cc-3089-11b2-a85c-c57d1a57929f.ibm.com (unknown [9.160.94.210])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 27 Aug 2020 00:53:34 +0000 (GMT)
Message-ID: <ced0c57308b0056396d4795a639e6d9686f0e163.camel@linux.ibm.com>
Subject: Re: IMA metadata format to support fs-verity
From:   Mimi Zohar <zohar@linux.ibm.com>
To:     Eric Biggers <ebiggers@kernel.org>,
        Chuck Lever <chuck.lever@oracle.com>
Cc:     linux-fscrypt@vger.kernel.org, linux-integrity@vger.kernel.org,
        Linux NFS Mailing List <linux-nfs@vger.kernel.org>
Date:   Wed, 26 Aug 2020 20:53:33 -0400
In-Reply-To: <20200826205143.GE2239109@gmail.com>
References: <760DF127-CA5F-4E86-9703-596E95CEF12F@oracle.com>
         <20200826183116.GC2239109@gmail.com>
         <6C2D16FB-C098-43F3-A7D3-D8AC783D1AB5@oracle.com>
         <20200826192403.GD2239109@gmail.com>
         <E7A87987-AF41-42AC-8244-0D07AA68A6E7@oracle.com>
         <20200826205143.GE2239109@gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.28.5 (3.28.5-12.el8) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-08-26_14:2020-08-26,2020-08-26 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 clxscore=1015
 bulkscore=0 mlxlogscore=847 spamscore=0 lowpriorityscore=0 impostorscore=0
 mlxscore=0 suspectscore=0 adultscore=0 malwarescore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2008260187
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Wed, 2020-08-26 at 13:51 -0700, Eric Biggers wrote:
> Of course, the bytes that are actually signed need to include not just the hash
> itself, but also the type of hash algorithm that was used.  Else it's ambiguous
> what the signer intended to sign.
> 
> Unfortunately, currently EVM appears to sign a raw hash, which means it is
> broken, as the hash algorithm is not authenticated.  I.e. if the bytes
> e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855 are signed,
> there's no way to prove that the signer meant to sign a SHA-256 hash, as opposed
> to, say, a Streebog hash.  So that will need to be fixed anyway.  While doing
> so, you should reserve some fields so that there's also a flag available to
> indicate whether the hash is a traditional full file hash or a fs-verity hash.

The original EVM HMAC is still sha1, but the newer portable & immutable
EVM signature supports different hash algorithms.

Mimi

