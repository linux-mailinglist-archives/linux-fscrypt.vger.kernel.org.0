Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 86415253B32
	for <lists+linux-fscrypt@lfdr.de>; Thu, 27 Aug 2020 02:51:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726786AbgH0AvJ (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 26 Aug 2020 20:51:09 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:14406 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726444AbgH0AvJ (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 26 Aug 2020 20:51:09 -0400
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 07R0W9Ev056435;
        Wed, 26 Aug 2020 20:51:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 mime-version : content-transfer-encoding; s=pp1;
 bh=cWagqHZABJ6iztMZ07nxmWL7AGR4xe7b/CRmkBxLuPQ=;
 b=nKSQBGwHPuwq8sdS2aGPMaqrSD2+sfS2RB1zBVtUc4tXyBWYZ4gD/W2RKijHyhs4sMfH
 iahbom8lcv778LipEPCl/aAtj5FSwEPt2pxtFRssVpkV61+SAqnqERjufgcRukLxWPT5
 oCRUk6NHp2/wrxzbAAQ6qdUnPF8GhNxsxfaWtFf8qHrxw6FWOs2Lhb0aMk4hrKqrG33R
 wy5OYfUpwWZZ+ftkXTECjBbyw4JwI9P66yScurriMKg/geLRWiMXWU4J2ai+CGLShr48
 5UTGPOZ1hH7L3Q6+EDSO1lAeBu29+r6uSk9RrtMG2x8tYqn31pOzoJBOJIMzbiorAc38 vA== 
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0a-001b2d01.pphosted.com with ESMTP id 335yfrvy4v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 26 Aug 2020 20:51:06 -0400
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 07R0mt6u025719;
        Thu, 27 Aug 2020 00:51:04 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma02fra.de.ibm.com with ESMTP id 332ujru4c2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 27 Aug 2020 00:51:04 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 07R0p1AW14549316
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 27 Aug 2020 00:51:02 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E24BF4C050;
        Thu, 27 Aug 2020 00:51:01 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 770C94C044;
        Thu, 27 Aug 2020 00:51:00 +0000 (GMT)
Received: from li-f45666cc-3089-11b2-a85c-c57d1a57929f.ibm.com (unknown [9.160.94.210])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 27 Aug 2020 00:51:00 +0000 (GMT)
Message-ID: <d565406cd0ae2d1649c0979a5f8445df2ae8ca41.camel@linux.ibm.com>
Subject: Re: IMA metadata format to support fs-verity
From:   Mimi Zohar <zohar@linux.ibm.com>
To:     Eric Biggers <ebiggers@kernel.org>,
        Chuck Lever <chuck.lever@oracle.com>
Cc:     linux-fscrypt@vger.kernel.org, linux-integrity@vger.kernel.org,
        Linux NFS Mailing List <linux-nfs@vger.kernel.org>
Date:   Wed, 26 Aug 2020 20:50:59 -0400
In-Reply-To: <20200826192403.GD2239109@gmail.com>
References: <760DF127-CA5F-4E86-9703-596E95CEF12F@oracle.com>
         <20200826183116.GC2239109@gmail.com>
         <6C2D16FB-C098-43F3-A7D3-D8AC783D1AB5@oracle.com>
         <20200826192403.GD2239109@gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.28.5 (3.28.5-12.el8) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-08-26_14:2020-08-26,2020-08-26 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 impostorscore=0 bulkscore=0 mlxlogscore=967 lowpriorityscore=0 spamscore=0
 mlxscore=0 malwarescore=0 suspectscore=0 adultscore=0 phishscore=0
 clxscore=1011 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008260187
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Wed, 2020-08-26 at 12:24 -0700, Eric Biggers wrote:

> fs-verity is mostly just a way of hashing a file.  Can't IMA just continue to do
> its signatures in the same way, and just swap out the traditional full file hash
> with the fs-verity file hash (when it's enabled)?

Yes, as previously discussed with you and Ted.

Mimi
> 
> fs-verity does support its own signature mechanism, because people wanted a
> simple knob to set that makes the kernel verify and enforce signatures for all
> fs-verity files.  But it's not mandatory to use that.

